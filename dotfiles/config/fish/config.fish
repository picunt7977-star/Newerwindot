if status is-interactive
    # Starship custom prompt
    command -v starship &> /dev/null && starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    command -v eza &> /dev/null && alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr l 'ls'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end

    # Custom fish config
    set -q XDG_CONFIG_HOME && set -l cConf $XDG_CONFIG_HOME/caelestia || set -l cConf $HOME/.config/caelestia
    source $cConf/user-config.fish 2> /dev/null
end

# Added by LM Studio CLI (lms)
# End of LM Studio CLI section

# Spaxer launcher
set -gx PATH $PATH $HOME/.local/bin

# Приветствие: neofetch-вид с логотипом Arch Linux, который крутится в 3D (~/.local/bin/ff-anim)
function fish_greeting
    if command -q ff-anim
        fastfetch -c arch-neofetch --logo none --pipe false | ff-anim
    else
        fastfetch -c arch-neofetch --logo arch
    end
end

# Связь с фоновым процессом ff-anim: сигнал + ожидание ответа (не дольше 0.3 с).
# USR1 — перед командой (логотип замирает), USR2 — перед prompt (продолжить, если экран
# не прокрутился), WINCH — перерисовать приветствие (Ctrl+L), TERM — остановить.
function __ff_anim_call --argument-names sig
    set -l f (set -q XDG_RUNTIME_DIR; and echo $XDG_RUNTIME_DIR; or echo /tmp)/ff-anim-$fish_pid
    test -f $f.pid; or return 1
    read -l pid <$f.pid
    if not kill -$sig $pid 2>/dev/null
        rm -f $f.pid $f.fifo $f.row
        return 1
    end
    test -p $f.fifo; and timeout 0.3 cat $f.fifo >/dev/null 2>&1
    return 0
end

function __ff_anim_stop
    __ff_anim_call TERM
end

function __ff_anim_preexec --on-event fish_preexec
    __ff_anim_call USR1
end

function __ff_anim_prompt --on-event fish_prompt
    set -l f (set -q XDG_RUNTIME_DIR; and echo $XDG_RUNTIME_DIR; or echo /tmp)/ff-anim-$fish_pid
    test -f $f.pid; or return
    # Где курсор — чтобы понять, не прокрутил ли вывод команды логотип за экран
    ff-anim-row >$f.row
    __ff_anim_call USR2
end

if status is-interactive
    bind ctrl-l '__ff_anim_call WINCH; or commandline -f clear-screen'
end

# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<
