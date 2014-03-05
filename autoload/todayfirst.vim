"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/today-first.vim
"VERSION:  0.1
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

function! todayfirst#cmd()
    let today = strftime("%Y%m%d", localtime())
    let before = readfile(g:today_first_dir.g:today_first_execute_datetime_file)[0]

    if today > before
        cgetexpr 'execute today-first-command...'
        copen

        call g:thread("ruby -e \" sleep 100ms; \"", function("todayfirst#cmdcore"))
    endif
    return ''
endfunction

function! todayfirst#cmdcore(...)
    redir @a
    silent call todayfirst#execute()
    redir END

    cclose
    cgetexpr @a
    copen

    return ''
endfunction

function! todayfirst#execute()
    let today = strftime("%Y%m%d", localtime())

    exec 'source '.g:today_first_dir.g:today_first_cmd_file
    call writefile([today], g:today_first_dir.g:today_first_execute_datetime_file, 'b')
endfunction

function! todayfirst#edit()
    exec 'e '.g:today_first_dir.g:today_first_cmd_file
endfunction

let &cpo = s:save_cpo
