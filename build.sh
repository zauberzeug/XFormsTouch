#!/bin/bash
set -x

if [[ $(git status -s) ]]; then
    echo "You have uncommitted files. Commit and push them before running this script."
  #  exit 1
fi

git fetch --tags

# get latest git tag and increase by one (see https://stackoverflow.com/questions/4485399/how-can-i-bump-a-version-number-using-bash)
VERSION=`git describe --abbrev=0 | awk -F. '/[0-9]+\./{$NF+=1;OFS=".";print}'`

echo "setting version to $VERSION"

XAMARIN_TOOLS=/Library/Frameworks/Mono.framework/Versions/Current/Commands/
NUGET="$XAMARIN_TOOLS/nuget"

function publishNuGet {
  git tag -a $VERSION -m ''  || exit 1
  git push --tags || exit 1

  nuget push $1 -Source https://www.nuget.org/api/v2/package || exit 1
}

rm -r XFormsTouch.NuGet/bin/Release/
$NUGET restore XFormsTouch.sln || exit 1

sed -i '' "s/\(<PackageVersion>\).*\(<\/PackageVersion>\)/\1$VERSION\2/" XFormsTouch.NuGet/XFormsTouch.NuGet.nuproj
msbuild /p:Configuration=Release XFormsTouch.NuGet/XFormsTouch.NuGet.nuproj || exit 1

publishNuGet XFormsTouch.NuGet/bin/Release/XFormsTouch.*.nupk
