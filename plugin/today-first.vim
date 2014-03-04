"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/today-first.vim
"VERSION:  0.1
"LICENSE:  MIT

if exists("g:loaded_today_first")
    finish
endif
let g:loaded_today_first = 1

let s:save_cpo = &cpo
set cpo&vim

let g:today_first_plugindir = expand('<sfile>:p:h:h').'/'
let g:today_first_templatedir = g:today_first_plugindir.'template/'

if !exists("g:today_first_cmd_file")
    let g:today_first_cmd_file = 'today_first_cmd.vim'
endif
if !exists("g:today_first_execute_datetime_file")
    let g:today_first_execute_datetime_file = 'execute_datetime'
endif
if !exists("g:today_first_dir")
    let g:today_first_dir = $HOME.'/.today_first_vim/'
endif

if !isdirectory(g:today_first_dir)
    call mkdir(g:today_first_dir)
    call system('cp '.g:today_first_templatedir.'* '.g:today_first_dir)
endif

function! TodayFirstCmd()
    let today = strftime("%Y%m%d", localtime())
    let before = readfile(g:today_first_dir.g:today_first_execute_datetime_file)[0]

    if today > before
        cgetexpr 'execute today-first-command...'
        copen

        call g:thread("ruby -e \" sleep 100ms; \"", function("TodayFirstCmdCore"))
    endif
    return ''
endfunction

function! TodayFirstCmdCore(...)
    redir @a
    silent call ExecuteTodayFirstCmd()
    redir END

    cclose
    cgetexpr @a
    copen

    call TodaySetBuf()

    return ''
endfunction

function! ExecuteTodayFirstCmd()
    let today = strftime("%Y%m%d", localtime())

    exec 'source '.g:today_first_dir.g:today_first_cmd_file
    call writefile([today], g:today_first_dir.g:today_first_execute_datetime_file, 'b')
endfunction

function! EditTodayFirstCmd()
    exec 'e '.g:today_first_dir.g:today_first_cmd_file
endfunction

command! TodayFirstCmd call TodayFirstCmd()
command! ExecuteTodayFirstCmd call ExecuteTodayFirstCmd()
command! EditTodayFirstCmd call EditTodayFirstCmd()

let &cpo = s:save_cpo
