"============================================================================
" FILE: autoload/jsonSchemaNav.vim
" AUTHOR: Quramy <yosuke.kurami@gmail.com>
"============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! jsonSchemaNav#get_nav_info(line)
  let hit = matchlist(a:line, '\m$ref:\s"#\/*\([^"]*\)"')
  if !len(hit) || hit[0] == ''
    return [0, {}]
  endif
  let fragments = split(hit[1], '/')
  let fileName = remove(fragments, 0)
  return [1, {
        \ "fileName": fileName,
        \ "fragments": fragments
        \ }]
endfunction

function! jsonSchemaNav#search(basename, level) 
  let target_dirs = split(expand('%:p'), '/')
  let pattern = '/'.join(target_dirs[0:-(a:level + 2)], '/').'/**/'.a:basename.'.yaml'
  let result = glob(pattern)
  if !strlen(result)
    return [0, '']
  else
    return [1, result]
  endif
endfunction

function! jsonSchemaNav#jump(fragments)
  call cursor(1, 1)
  for fragment in a:fragments
    let pattern = '\m^\s*'.fragment.':'
    let result = search(pattern)
    if !result
      break
    endif
  endfor
endfunction

function! jsonSchemaNav#goto()
  let [code, info]= jsonSchemaNav#get_nav_info(getline('.'))
  if !code
    return
  endif

  if info.fileName == expand('%:t')
    call jsonSchemaNav#jump(info.fragments)
    return
  endif

  let [code, filepath] = jsonSchemaNav#search(info.fileName, 2) "TODO
  if !code
    echom 'Not found '.info.fileName
    return
  endif
  let strs = []
  for f in info.fragments
    call add(strs, '"'.f.'"')
  endfor
  execute('edit +call\ jsonSchemaNav#jump(['.join(strs, ',').']) '.filepath)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
