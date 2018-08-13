# vim-colorspace
* Show color palete in split buffer. 
* Chose color with cursor keys. 
* Copy color number to clipboard "\* with enter.
* various functions dealing with colors and color palettes

# Dependency
* true color terminal
* vim-genstr
* vim-buffer
* vim-array

# Mapping 
* show pallete in splitbuffer
- nnoremap <leader>a :silent call colorspace#ColorSpaceShow()<CR>
* automatic mapping local to color palette buffer
- Enter - copy color under cursor to "\* buffer

# Usage
[![vim-colorspace.gif](https://s22.postimg.cc/k7agc0j6p/vim-colorspace.gif)](https://postimg.cc/image/h0fwsdyql/)

# Testting
* There are commented tests. Tests can be run conveniently with vim-runner plugin.

# Notes
-works in gvim
-for using the plugin in terminal + tmux consult https://digitalwords.net/st-tmux-tc-italics/
-example command to run st terminal on debian:
stterm -f "Bitstream Vera Sans Mono:size=20:antialias=true:autohint=true"

