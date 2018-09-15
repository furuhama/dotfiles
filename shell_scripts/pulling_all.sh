#!/usr/bin/env sh

git_repos=( \
  "9cc master" \
  "codesearch master" \
  "gauche master" \
  "gitlab-ce master" \
  "golang master" \
  "gvisor master" \
  "lld master" \
  "mastodon master" \
  "openal-soft master" \
  "openssl master" \
  "rails master" \
  "regex master" \
  "ruby trunk" \
  "rust master" \
  "servo master" \
  "tor master" \
)

svn_repos=( \
  "firefox" \
)

# pulling all git repositories
function git_pull() {
  for repo_and_branch in "${git_repos[@]}"; do
    # shadowing `repo_and_branch` variable to str->array casting
    local repo_and_branch=(${repo_and_branch[@]})
    local repo=${repo_and_branch[0]}
    local branch=${repo_and_branch[1]}

    cd ${repo}
    echo "start pulling => ${repo} [${branch}]"
    git pull --rebase origin ${branch}
    echo "end\n"
    cd ..
  done
}

# pulling all svn repositories
function svn_pull() {
  for repo in "${svn_repos[@]}"; do
    cd ${repo[0]}
    echo "start pulling => ${repo[0]}"
    hg pull --rebase
    echo "end\n"
    cd ..
  done
}

# main function
function main() {
  git_pull
  svn_pull
}
main
