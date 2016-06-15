"============================================================================
" FILE: ftplugin/yaml.vim
" AUTHOR: Quramy <yosuke.kurami@gmail.com>
"============================================================================

scriptencoding utf-8

command! -buffer SchemaDef :call jsonSchemaNav#goto()
noremap <silent> <buffer> <Plug>(SchemaDef)     :SchemaDef <CR>
map <buffer> <C-]> <Plug>(SchemaDef)

