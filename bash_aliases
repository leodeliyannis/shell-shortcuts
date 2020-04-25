#
# ~/.bash_aliases
#

#################
#### ALIASES ####
#################

# General aliases
alias ls='ls --group-directories-first --color=auto'
alias grep='grep --color=auto'
alias fixit='sudo rm /var/lib/pacman/db.lck'
alias subl=subl3

alias cp='cp -i'                    # Confirm before overwriting something
alias mv='mv -i'                    # Confirm before overwriting something
alias df='df -h'                    # Human-readable sizes
alias free='free -m'                # Show sizes in MB
alias gitu='git add . && git commit && git push'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# youtube-dl aliases
alias youtube-dl='youtube-dl -o "%(title)s.%(ext)s"'
alias ytmp3='youtube-dl --extract-audio --audio-format mp3'
alias ytogg='youtube-dl --extract-audio --audio-format vorbis'

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias e='vim -p'
alias evince='evince 2> /dev/null'

cr8(){
    fname=$(echo $1 | cut -f1 -d.)
    ext=$(echo $1 | cut -f2 -d.)
    cat ~/.template.$ext > $1
    touch $fname.in $fname.sol my.sol
    e $fname.{$ext,in,sol} my.sol 
}

run(){
    fname=$(echo $1 | cut -f1 -d.)
    ext=$(echo $1 | cut -f2 -d.)
    compilationOkMessage="### COMPILATION SUCCESS! ###\n### Running... ###"
    if [ -f $1 ] ; then
        case $1 in
            *.c)
                gcc -Wall -std=c99 $1 && echo $compilationOkMessage && \
                time ./a.out < $fname.in > my.sol && diff $fname.sol my.sol ;;
            *.cpp)
                g++ -Wall -std=c++11 $1 && echo $compilationOkMessage && \
                time ./a.out < $fname.in > my.sol && diff $fname.sol my.sol ;;
            *.cc)
                g++ -Wall -std=c++11 $1 && echo $compilationOkMessage && \
                time ./a.out < $fname.in > my.sol && diff $fname.sol my.sol ;;
            *.java)
                javac $1 && echo $compilationOkMessage && \
                time java Main < $fname.in > my.sol && diff $fname.sol my.sol ;;
            *.py)
                time python3 $1 < $fname.in > my.sol && diff $fname.sol my.sol ;;
            *.kt)
                kotlinc $1 -include-runtime -d $fname.jar && echo $compilationOkMessage && \
                time java -jar $fname.jar < $fname.in > my.sol && diff $fname.sol my.sol ;;
            *)
                echo "'$1' cannot be compiled or executed via run()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
