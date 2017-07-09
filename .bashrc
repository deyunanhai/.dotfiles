# .bashrc

alias ls='ls -G'
alias vi='vim'

export ANDROID_NDK_ROOT=/Users/hu.hua/android-ndk-r8d
export ANDROID_HOME=/Users/hu.hua/android-sdk-macosx
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

source ~/.nvm/nvm.sh
nvm use "0.10.2" >/dev/null

export PATH=${PATH}:~/Documents/server/mysql-5.6.10-osx10.7-x86_64/bin:~/android-sdk-macosx/platform-tools

#set -o vi
PATH="/Users/bocellisoft/.conscript/bin:$PATH"
