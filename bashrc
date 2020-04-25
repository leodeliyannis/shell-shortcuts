#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=4000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Import aliases and functions from separate file
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
# xmodmap -e "keycode 105 = backslash bar"

PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command() {
    local EXIT="$?"             # This needs to be first
    
    local NENHUMA='\[\033[00m\]'
    
    local BRANCA='\[\033[00;37m\]'
    local VERDE_B='\[\033[01;92m\]'
    local VERDE='\[\033[00;92m\]'
    local AZUL='\[\033[01;94m\]'
    local ANIL='\[\033[00;34m\]'
    local VERMELHO='\[\033[00;91m\]'
    local VERMELHO_B='\[\033[01;91m\]'
    local AMARELO='\[\033[01;93m\]'
    local LILAS='\[\033[01;95m\]'
    local MAGENTA='\[\033[00;95m\]'
    local AGUA='\[\033[00;36m\]'
    local CIANO='\[\033[01;96m\]'
    
    PS1="${debian_chroot:+($debian_chroot)}\n"
    if [ $EXIT != 0 ]; then
        PS1+="${VERMELHO}>${VERMELHO_B}>"
    else
        PS1+="${VERDE}>${VERDE_B}>"
    fi
    PS1+="${NENHUMA} "
    if [ "$(id -u)" != "0" ]; then
        PS1+="${CIANO}" 
    else 
        PS1+="${VERMELHO}"
    fi
    PS1+="\u${NENHUMA}@${AZUL}\h${NENHUMA}: ${MAGENTA}\w${NENHUMA}\n"
    PS1+="${AZUL}[${NENHUMA}\t${AZUL}]${NENHUMA} \$ "
}

PATH=".:~/.local/bin:~/bin:$PATH"
export PATH

[ -f /etc/profile.d/autojump.bash ] && . /etc/profile.d/autojump.bash
# >>> Added by cnchi installer
BROWSER=/usr/bin/firefox # [firefox|chromium]
EDITOR=/usr/bin/vim # [vim|nano]

#################
### FUNCTIONS ###
#################

function em () {
    command emacs "$@" &> /dev/null &
}

function xfigue () {
    command xfig -specialtext -latexfonts -startlatexFont default "$@" &> /dev/null &
}

function swap()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE $2
}

## Function de criacao de arquivos
## USO: cria arquivo.(cpp|py)

MY_EDITOR=subl3

function cria(){
    arq=$(echo $1 | cut -f1 -d.)
    ext=$(echo $1 | cut -f2 -d.)
    cat ~/modelo.$ext > $arq.$ext
    > $arq.in 
    if [ "$ext" != "sql" ]; then
      > $arq.sol > my.sol ;
    fi
    $MY_EDITOR $arq.$ext $arq.in
    if [ "$ext" != "sql" ]; then
      $MY_EDITOR $arq.sol my.sol ;
    fi
    $MY_EDITOR $arq.$ext
}


## Function de compilacao, execucao e teste
## USO: roda arquivo.(cpp|py|sql)

function roda(){
    arq=$(echo $1 | cut -f1 -d.)
    ext=$(echo $1 | cut -f2 -d.)
    case $ext in
      "cpp")
        g++ -Wall -std=c++11 -lm -O2 $arq.cpp &&
        echo "### COMPILOU ###" &&
        time ./a.out < $arq.in > my.sol && 
        diff $arq.sol my.sol
      ;;
      "java")
        javac $arq.java &&
        echo "### COMPILOU ###" &&
        time java Main < $arq.in > my.sol && 
        diff $arq.sol my.sol
      ;;
      "py")
        python -m py_compile $arq.py &&
        echo "### COMPILOU ###" &&
        time python3 $arq.py < $arq.in > my.sol &&
        diff $arq.sol my.sol
      ;;
      "sql")
        psql -lqt | cut -d \| -f 1 | grep -qw $arq &&
        psql -q -d postgres -c "DROP DATABASE $arq;"
        psql -q -d postgres -c "CREATE DATABASE $arq;" &&
        psql -q -d $arq -c "\i $arq.in;" &&
        time psql -d $arq -c "\i $arq.sql;" &&
        psql -q -d postgres -c "DROP DATABASE $arq;"
      ;;
    esac
}

