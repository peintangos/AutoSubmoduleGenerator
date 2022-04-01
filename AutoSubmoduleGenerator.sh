#!/bin/bash

branchPrefix="feature"
branchSuffix="submodule_update"
submodule="submodule"
log="*****"
autoPrPractice="auto_pr_practice"
targetiOSRepositoryName="Varadero-iOS"
targetAndroidRepositoryName="VaraderoAndroid"
targetSubmoduleRepositoryName="varadero-web"
DIR=/usr/local/Homebrew
mergedBranch="master"
jiraNumber=$1
branchName


if [ $# != 1 ]; then
echo "JIRA番号を入力してください。"
exit 1
else
branchName=${branchPrefix}/VRDR-${jiraNumber}/${branchSuffix}
echo "ブランチ名:${branchName}"
fi

function cloneGitCli(){
    brew install gh
}

echo "サブモジュールのプルリクの自動作成を開始します。"

if [ ! -d $DIR ];then
echo "HomeBrewをインストールします。"
cloneGitCli
fi

# echo "HomeBrewをインストールを終了します。"
function createPR(){

echo "$1のサブモジュールを更新します。"

cd $HOME/Projects/${autoPrPractice}/$1/${targetSubmoduleRepositoryName}
git fetch
git reset --hard origin/${mergedBranch}
echo "$1のサブモジュールを更新を終了します。"

echo "$1にてブランチを最新化します。"
cd $HOME/Projects/${autoPrPractice}/$1
git fetch
git reset --hard origin/${mergedBranch}
echo "$1にてブランチを最新化を終了します。"

echo "${branchName}にcheckoutします。"
git checkout -b ${branchName}
echo "${branchName}にcheckoutを終了します。"

echo "git addします。"
git add $HOME/Projects/${autoPrPractice}/$1
echo "git addを終了します。"

echo "git commitします。"
git commit -m "[VRDR-${jiraNumber}]サブモジュールのアップデート"
echo "git commitを終了します。"

echo "git push　をします。"
git push -f origin ${branchName}
echo "git push　を終了します。"

echo "GHEにログインします。"
gh auth login -p ssh

echo "プルリクを作成します。"
gh pr create -B ${mergedBranch} -b "サブモジュールのプルリクとなります。" -t "[VRDR-${jiraNumber}]サブモジュールアップデート"
}

createPR ${targetiOSRepositoryName}
createPR ${targetAndroidRepositoryName}