  #!/bin/bash
set -x

if [[ $(git status -s) ]]; then
    echo "You have uncommitted files. Commit and push them before running this script."
    exit 1
fi

# get latest git tag and increase by one (see https://stackoverflow.com/questions/4485399/how-can-i-bump-a-version-number-using-bash)
VERSION=`git describe --abbrev=0 | awk -F. '/[0-9]+\./{$NF+=1;OFS=".";print}'`

echo "setting version to $VERSION"

XAMARIN_TOOLS=/Library/Frameworks/Mono.framework/Versions/Current/Commands/
NUGET="$XAMARIN_TOOLS/nuget"
XBUILD="$XAMARIN_TOOLS/xbuild"
MONO="$XAMARIN_TOOLS/mono"

ls $XAMARIN_TOOLS

function setVersion_Nupkg {
  sed -i '' "s/\(<version>\).*\(<\/version>\)/\1$VERSION\2/" $1
}

function setGitHead_Nupkg {
  HEAD=$( git rev-parse HEAD )
  HEAD=" (HEAD: $HEAD)"
  sed -i '' "s/\(<description>\)\(.*\)\(<\/description>\)/\1\2$HEAD\3/" $1
}


function packNuGet {
	setVersion_Nupkg $1
	setGitHead_Nupkg $1
	$NUGET pack $1 || exit 1
}

function publishNuGet {
  git add $1
  git commit -am "nuget package ${VERSION}" || exit 1
  git tag -a $VERSION -m ''  || exit 1

  git push
  git push --tags

  echo "not publishing to nuget.org yet"
  #nuget push $1
}

function updateAssemblyInfos {
    DIRECTORY=$1
    echo "Update AssemblyInfo.cs files:"
    ASSEMBLY_INFOS=$(find $DIRECTORY -iname "assemblyinfo.cs")
    for ASSEMBLY_INFO in $ASSEMBLY_INFOS;
    do
        echo "Updating $ASSEMBLY_INFO"
        sed -E -i '' "s/AssemblyVersion.*\(.*\)/AssemblyVersion\(\"$VERSION\"\)/" $ASSEMBLY_INFO
        sed -E -i '' "s/AssemblyFileVersion.*\(.*\)/AssemblyFileVersion\(\"$VERSION\"\)/" $ASSEMBLY_INFO
    done
}

$NUGET restore Xamarin.Piwik.sln || exit 1
updateAssemblyInfos .

$XBUILD /p:Configuration=Release Xamarin.Piwik.sln || exit 1

pushd packages && nuget install Nunit.Runners && popd
export MONO_IOMAP=all # this fixes slash, backslash path seperator problems within nunit test runner
NUNIT="mono packages/NUnit.ConsoleRunner.*/tools/nunit3-console.exe"
$NUNIT -config=Release "Tests/Tests.csproj" || exit 1

packNuGet Xamarin.Piwik.nuspec
publishNuGet Xamarin.Piwik.$VERSION-pre.nupkg
