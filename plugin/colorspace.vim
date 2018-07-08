""SHOW COLORSPACE
"DEPENDENCIES:
"genstr#

"TODO:"
"4. Last used colors list
"5. favorite colors
"6. increase red, increase blue, increase green

"GET LIST OF SYSTEM COLOR NAMES:
function! colorspace#GetNames()
	let l:fcolors="$VIMRUNTIME" . "/rgb.txt"
	let l:colornames=systemlist("cat " . l:fcolors)
	return l:colornames
endfunction
""echo colorspace#GetNames()

"CONVERT HEX COLOR TO RGB NUMBER:
function! colorspace#HexExtract(hexcolor)
	""Check if color number is of correct format:
	let l:fmtcheck=match(a:hexcolor,'^#.\{6}$')
	if l:fmtcheck==-1
		echo "Provided string is not hex color."
	else
		let l:hexnum='0X' . matchstr(a:hexcolor,'^#\zs.*')
		return printf('%06X',l:hexnum)
	endif
endfunction
""echo colorspace#HexExtract("#0000AA")

""CONVERT HEX COLOR TO RGB VECTOR:
function! colorspace#Hex2Rgbv(hexcolor,hexORdec)
	let l:hexcolor=colorspace#HexExtract(a:hexcolor)
	let l:r=matchstr(l:hexcolor,'^.\{2}')
	let l:g=matchstr(l:hexcolor,'^.\{2}\zs.\{2}\ze')
	let l:b=matchstr(l:hexcolor,'^.\{4}\zs.\{2}\ze')
	let l:cvector=[l:r,l:g,l:b]
	if a:hexORdec ==? 'hex'
	elseif a:hexORdec ==? 'dec'
		for l:i in range(0,2,1)
			let l:cvector[l:i]=str2nr(printf('%d','0X' . l:cvector[l:i]))
		endfor
	else
		echoerr "Number format not recognized"
	endif
	return l:cvector
endfunction
"echo colorspace#Hex2Rgbv("#ABCDEF","dec")

""CONVERT RGB VECTOR TO RGB HEX COLOR:
function! colorspace#Rgbv2Hexc(rgbv)
	let l:rgb=[]
	for l:i in range(0,2,1)
		let l:conv=printf('%02X',a:rgbv[l:i])
		call add(l:rgb,l:conv)
		let l:joined='#' . join(l:rgb,'')
	endfor
	return l:joined
endfunction
""echo colorspace#Rgbv2Hexc([0,15,15])

"GET HEX COLOR ITEM UNDER CURSOR AND PUT IT IN REGISTR:"
function! colorspace#GetColor()
	let l:color=synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")
	echo l:color
	let @" = l:color
endfunction
""echo colorspace#GetColor()

""GET LIST OF PATTERNS WHICH MATCHES SEQUENTIALLY AND SEPARATELY ALL CHARACTERS IN WINDOW:
function! colorspace#ColorPattern(rows,columns)
	let l:k=0
	let l:pattls=[]
	let l:charspc=genstr#Charspaces('aZ10')
	for l:h in range(1,a:rows,1)
		for l:w in range(1,a:columns,1)
			let l:pattc=strcharpart(l:charspc,l:w-1,1)
			let patt='\%' . l:h . 'l' . l:pattc
			""echo l:patt
			""let patt=CharMatcher(l:w,l:h,1)
			call add(pattls,patt)
		endfor
	endfor
	return pattls
endfunction
""echo colorspace#ColorPattern(10,10)

""echo colorspace#ColorPattern(10,10)
""GET LIST OF COLORS FROM COLORSPACE:
function! colorspace#ColorSequence(ncolors,lbound,step)
	let l:colorlist=[]
	let l:ubound=a:step*(a:ncolors-1)
	for l:i in range(a:lbound,l:ubound,a:step)
		let l:color='#' . printf('%06x',l:i)
		call add(l:colorlist,l:color)
	endfor
	return colorlist
endfunction
""echo colorspace#ColorSequence(99,0,200)
""echo len(colorspace#ColorSequence(99,0,100))

""GENERATE SEQUENCE OF SPECIFIED COLOR:
function! colorspace#ColorRGBseq(rgb,onum1,onum2)
	let l:vec=[]
	let l:length=255
	for l:i in range(0,l:length,8)
		if a:rgb==? 'r'
			""generate reds with tint
			let l:cvec=[l:i,a:onum1,a:onum2]
		elseif a:rgb==? 'g'
			""generate greens with tint
			let l:cvec=[a:onum1,l:i,a:onum2]
		elseif a:rgb==? 'b'
			""generate blues with tint
			let l:cvec=[a:onum1,a:onum2,l:i]
		endif
		let l:rgb=colorspace#Rgbv2Hexc(l:cvec)
		call add(l:vec,rgb)
	endfor
	return l:vec
endfunction
""echo colorspace#ColorRGBseq('g',10,14)

function! colorspace#ColorPaleteGray(length)
	let l:step=255/a:length
	let l:vec=[]
	for l:i in range(0,255,l:step)
		let l:gc=colorspace#Rgbv2Hexc([l:i,l:i,l:i])
		call add(l:vec,l:gc)
	endfor
	return l:vec
endfunction
""echo ColorGrayScale(10)

""SPECIFY PALETES WHICH WILL BE SHOWN:
function! colorspace#ColorPaletesList()
	let l:colorlist=[]

	""REDS with green tint
	let l:colorlist+=colorspace#ColorRGBseq('r',0,0)
	let l:colorlist+=colorspace#ColorRGBseq('r',50,0)
	let l:colorlist+=colorspace#ColorRGBseq('r',100,0)
	let l:colorlist+=colorspace#ColorRGBseq('r',150,0)
	let l:colorlist+=colorspace#ColorRGBseq('r',200,0)
	let l:colorlist+=colorspace#ColorRGBseq('r',255,0)

	""GREENS with blue tint
	let l:colorlist+=colorspace#ColorRGBseq('g',0,0)
	let l:colorlist+=colorspace#ColorRGBseq('g',0,50)
	let l:colorlist+=colorspace#ColorRGBseq('g',0,100)
	let l:colorlist+=colorspace#ColorRGBseq('g',0,150)
	let l:colorlist+=colorspace#ColorRGBseq('g',0,200)
	let l:colorlist+=colorspace#ColorRGBseq('g',0,255)
	"
	""BLUES with red tint
	let l:colorlist+=colorspace#ColorRGBseq('b',0,0)
	let l:colorlist+=colorspace#ColorRGBseq('b',50,0)
	let l:colorlist+=colorspace#ColorRGBseq('b',100,0)
	let l:colorlist+=colorspace#ColorRGBseq('b',150,0)
	let l:colorlist+=colorspace#ColorRGBseq('b',200,0)
	let l:colorlist+=colorspace#ColorRGBseq('b',255,0)

	let l:colorlist+=colorspace#ColorRGBseq('b',125,50)
	let l:colorlist+=colorspace#ColorRGBseq('b',125,100)
	let l:colorlist+=colorspace#ColorRGBseq('b',125,150)
	let l:colorlist+=colorspace#ColorRGBseq('b',125,200)
	let l:colorlist+=colorspace#ColorRGBseq('b',125,255)

	let l:colorlist+=colorspace#ColorRGBseq('b',50,50)
	let l:colorlist+=colorspace#ColorRGBseq('b',50,100)
	let l:colorlist+=colorspace#ColorRGBseq('b',50,150)
	let l:colorlist+=colorspace#ColorRGBseq('b',50,200)
	let l:colorlist+=colorspace#ColorRGBseq('b',50,255)

	let l:colorlist+=colorspace#ColorRGBseq('b',200,50)
	let l:colorlist+=colorspace#ColorRGBseq('b',200,100)
	let l:colorlist+=colorspace#ColorRGBseq('b',200,150)
	let l:colorlist+=colorspace#ColorRGBseq('b',200,200)
	let l:colorlist+=colorspace#ColorRGBseq('b',200,255)
	
	""GREY PALETE
	let l:colorlist+=colorspace#ColorPaleteGray(22)

	return l:colorlist
endfunction
""echo colorspace#ColorPaletesList()

function! colorspace#ColorApply(paletes)
	let l:lenpaletelist=len(a:paletes)
	""number of rows which paletes takes
	let l:wh=float2nr(ceil(l:lenpaletelist/60.0))
	let matchpatt=colorspace#ColorPattern(l:wh,60)
	for l:i in range(0,l:lenpaletelist-1,1)
		let l:hname="DynColor" . l:i
		let l:hicommand='highlight ' . l:hname . ' guibg=' . a:paletes[l:i].  ' guifg=' . a:paletes[l:i]
		let l:mcommand='syn match ' . l:hname . ' ' . shellescape(l:matchpatt[l:i])
		exe l:hicommand
		exe l:mcommand
	endfor
endfunction
""let plts=colorspace#ColorPaletesList()
""echo colorspace#ColorApply(plts)

function! colorspace#ColorSpaceShow()
	"Generate dummy string
		let l:charspc=g:genstr#CharspacesList.aZ10
		let l:maxstr=strlen(l:charspc)
		let l:ww=winwidth(0)-3
		let l:ww=(l:ww > l:maxstr) ? l:maxstr : l:ww
		""let l:wh=winheight(0)
		let l:paletes=colorspace#ColorPaletesList()
		let l:lenpaletes=len(paletes)
		let l:rows=str2nr(l:lenpaletes/l:ww)
		echo l:rows
		let l:texti=genstr#StringVectorSpanLRand(l:charspc,l:rows,l:ww,l:ww)
	""Create or go to buffer
		let l:bufname="ColorPaletes"
		call buffer#GoToScratch(l:bufname,l:rows)
	"Delete content of buffer and put dummy string in it"
		%d_
		0put = l:texti
		$d_
	"Apply coloring syntax
		syn clear
		call colorspace#ColorApply(l:paletes)
		nnoremap <buffer> <silent> <CR> :call colorspace#GetColor()<CR>
endfunction
"call colorspace#ColorSpaceShow()
"call buffer#GoToScratch("bufo",10)
