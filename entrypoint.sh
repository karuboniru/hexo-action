#!/bin/sh

set -e

# setup ssh-private-key
mkdir -p /root/.ssh/
echo "$INPUT_DEPLOY_KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

mkdir ~/tools -p
curl -s -L https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-linux.tar.gz | tar xvzf - -C ~/tools
export PATH="$PATH:~/tools/pandoc-2.7.3/bin"
# setup deploy git account
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# install hexo env
npm install hexo-cli -g
npm install hexo-deployer-git --save

git clone https://github.com/$GITHUB_ACTOR/$GITHUB_ACTOR.github.io.git .deploy_git


# deployment
if [ "$INPUT_COMMIT_MSG" == "" ]
then
    hexo g -d
else
    hexo g -d -m "$INPUT_COMMIT_MSG"
fi

echo ::set-output name=notify::"Deploy complate."
