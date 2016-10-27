# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="af-magic"
# ZSH_THEME="soliah"
ZSH_THEME="pygmalion"


# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vim=mvim
#alias vim="open -a MacVim"
alias svim=/usr/bin/vim
alias ct="ctags -R --exclude=target --exclude=vendor -f ./.git/tags ."
alias alog='git log --date-order --all --graph --date=short --format="%C(green)%h%Creset %C(yellow)%an%Creset %C(blue bold)%ad%Creset %C(red bold)%d%Creset%s"'
alias hlog='git log --date-order --graph --date=short --format="%C(green)%h%Creset %C(yellow)%an%Creset %C(blue bold)%ad%Creset %C(red bold)%d%Creset%s"'
alias gs='git status'
alias groot='cd $(git rev-parse --show-cdup)'
alias cbr='cargo build --release --features nightly --no-default-features'
alias cbd='cargo build --features nightly --no-default-features'
# alias ct='cargo test'
alias clrest='RUST_LOG=info RUST_BACKTRACE=1 ./target/debug/clipper-rest start --conf conf/test.toml'
alias tcpd1337="sudo tcpdump -s 0 -A -i lo0 'tcp port 1337 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


export ARCHFLAGS="-arch x86_64"
# only run pip if in a virtualenv
# export PIP_REQUIRE_VIRTUALENV=true
# export PIP_REQUIRE_VIRTUALENV=false
# cache pip-installed packages to avoid re-downloading
# export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

export EDITOR="vim"

# tmux plugin flags
# export ZSH_TMUX_ITERM2="true"

export GREP_OPTIONS='--color=auto'
# export GREP_COLOR='1;30;40'
export GREP_COLORS="rv:38;5;230:sl=38;5;240:cx=38;5;100:mt=33;1;38;5;161:fn=38;5;197:ln=38;5;212:bn=38;5;44:se=38;5;166"

#rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# export PYTHONPATH=`brew --prefix`/lib/python2.7/site-packages:$PYTHONPATH
export JAVA_HOME=$(/usr/libexec/java_home)
export GOPATH=$HOME/go



# Customize to your needs...
export PATH=/Users/crankshaw/anaconda2/bin:/usr/texbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin:/Users/crankshaw/.cargo/bin:/usr/local/sbin
export CARGO_HOME=$HOME/.cargo
export RUST_SRC_PATH=/usr/local/src/rustc-1.8.0/src
export PKG_CONFIG_PATH=/usr/local/Cellar/zeromq/4.1.5/lib/pkgconfig/

# virtualenv directives
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/code/python
# export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
# source /usr/local/bin/virtualenvwrapper_lazy.sh
# source /usr/local/bin/virtualenvwrapper.sh
source ~/aws_creds.sh
# plugins=(git brew virtualenv virtualenvwrapper pip osx history-substring-search)
plugins=(git brew osx history-substring-search mvn conda docker)
source $ZSH/oh-my-zsh.sh
# export SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M  -Duser.timezone=GMT"
# export MAVEN_OPTS="-Xmx4g -XX:MaxPermSize=4000M -XX:ReservedCodeCacheSize=512m"
# export SPARK_HOME="$HOME/model-serving/spark-1.6.0-bin-hadoop2.4"
# export PYSPARK_SUBMIT_ARGS="--master local[2]"
# export VELOX_CLUSTER_KEY=~/.ssh/aws_rsa
# eval "$(jenv init -)"
export HOMEBREW_GITHUB_API_TOKEN="4a156db4f3918d79054031ab9c5e4f2071e21186"
export OPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include
export DEP_OPENSSL_INCLUDE=/usr/local/opt/openssl/include

# function title {
#     echo -ne "\033]0;"$*"\007"
# }

# from http://stackoverflow.com/questions/17033096/homebrew-mac-change-python-path
export PYTHONPATH=/Users/crankshaw/model-serving/caffe/python:$PYTHONPATH
# bindkey -v

# OPAM configuration
. /Users/crankshaw/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
