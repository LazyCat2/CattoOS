--apps
#include "apps/settings.lua"
#include "apps/timer.lua"
#include "apps/test.lua"
#include "apps/notepad.lua"
#include "apps/taskbar.lua"

--for draw function
#include "draw/softBlur.lua"
#include "draw/contextMenu.lua"
#include "draw/moreTransparency.lua"
#include "draw/resize.lua"
#include "draw/screenSaver.lua"
#include "draw/windows.lua"

function init()
	taskbarsize=100

	files={{name="README.txt", content=(
		"F5 - Enter resize mode\n"..
		"Use WASD in resize mode, hold shift for more speed, F5 again to exit\n"..
		"F6 - Toggle fullscreen\n"..
		"Desktop has context menu, press RBM to open it\n"..
		"Also you can drag n drop windows\n"..
		"1920x1080 is recomended\n"..
		"alt + F4 really works, it closes windows, not teardown\n"..
		"To exit click button in left bottom corner then off button"
	)}}

	windows = {{
		render=Notepad, 
		posX=500, posY=500, 
		sizeX=1000, sizeY=500,
		file=files[1]['name'], text=files[1]['content']
	}}
	--[[
		{
			render="Draw function",
	
			posX="Position on X",
			posY="Position on Y",
	
			sizeX="Size on X",
			sizeY="Size on Y",

			full="Is window in fill screen",
			dnd="Uses to know what window drag and drops rn",
			min="Is window minimized"
		}
	]]

	apps={
		{program=Settings, icon="stng.png", name="Settings"},
		{program=Notepad, icon="notepad.png", name="Notepad"},
		{program=Test, icon="test.png", name="Test"},
		{program=Time, icon="time.png", name="Time"},
		{program=Menu, icon="off.png", name="Turn off"}
	} 

	msg=''
	showLauncher=false
	debug=false
	resizeMode=false
	
	showContextMenu=false
	ContextMenuX=0
	ContextMenuY=0
	ContextMenuSizeX=300
	ContextMenuSizeY=350

	dnd=false --Drag n drop
	dndAttachX=0
	dndAttachY=0

	selected=nil
	TaskbarSelected=0

	maxWindowSize=UiHeight()-150
	minWindowSize=250

	if not GetBool('savegame.mod.playedBefore') then
		TaskbarBlur=true
		WindowBlur=true
		MsgBlur=true
		ContextMenuBlur=true
		SoftBlur=false
		EyeBurn=false
		MoreTrs=false
		SSE=true --Screen saver enabled
		STB=false --Small taskbar

		SetBool('savegame.mod.playedBefore', true)
	else
		TaskbarBlur=GetBool('savegame.mod.TaskbarBlur')
		WindowBlur=GetBool('savegame.mod.WindowBlur')
		MsgBlur=GetBool('savegame.mod.MsgBlur')
		ContextMenuBlur=GetBool('savegame.mod.ContextMenuBlur')
		SoftBlur=GetBool('savegame.mod.SoftBlur')
		EyeBurn=GetBool('savegame.mod.EyeBurn')
		MoreTrs=GetBool('savegame.mod.MoreTrs')
		SSE=GetBool('savegame.mod.SSE')
		STB=GetBool('savegame.mod.STB')
	end

	if STB then taskbarsize=50 end

	if SoftBlur then BlurAmt=0.5 else BlurAmt=1 end
	if MoreTrs then TrsMlt=0.5 else TrsMlt=1 end

	LastTimeMove=-1
	LastX=-1 LastY=-1
	ScreenSaver=false
	LogoX=0 LogoY=0
	LogoMoveX=true
	LogoMoveY=true
end

function Remove(list)
	l={}
	for i=1,#list do
		if list[i] ~= nil and not list[i]['close'] then 
			l[#l+1]=list[i]
		end
	end
return l end

function SetTransparent(bg, trs)
	if bg and not ScreenSaver then trs=(trs or 1)*TrsMlt --Don't make [text and screen saver bg] transparent
	else trs=1 end
	
	if 
		(EyeBurn and bg) or --Light mode, bg
		(not (EyeBurn or bg)) --Dark mode, text
	then 
		UiColor(1, 1, 1, trs)
	else 					 --[Light mode, text] or [Dark mode, bg]
		UiColor(0, 0, 0, trs)
	end
end

function Write(file, text)
	for i=1,#files do
		if files[i]['name']==file then
			files[i]['content']=text
			zxc=true
		end
	end

	if not zxc then
		files[#files+1]={
			name=file, content=text
		}
	end
end

function Read(file)
	for i=1,#files do
		if files[i]['name']==file then
			return files[i]['content']
		end
	end
end

function GetInput(onlyF)
	variants = {' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '.'}
	variants_shift={'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
	variants_no_shift={'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
	variants_f={'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'}

	if onlyF then
		for i=1,#variants_f do
			if InputPressed(variants_f[i]) then return variants_f[i] end
		end
		return nil
	end

	for i=1,#variants do
		if InputPressed(variants[i]) then
			return variants[i]
		end
	end

	for i=1,#variants_shift do
		if InputPressed(variants_shift[i]) then
			if InputDown('shift') then
				return variants_shift[i]
			else
				return variants_no_shift[i]
			end
		end
	end
	return nil
end

function NumInRange(num, min, max) 
	return (num <= max and num >= min)
end

function max(a, b)
	if a >= b then return a else return b end
end

function min(a, b)
	if a <= b then return a else return b end
end

function draw(td)
	x, y = UiGetMousePos()
	selected=nil
	UiMakeInteractive()

	SoftBlurDraw(td)
	MoreTransparentDraw(td)

	if SSE then
		ScreenSaverDraw(td)
		if ScreenSaver then 
			return WindowsDraw(td)
		end
	end

	--Wallpaper
	UiPush()
		UiTranslate(UiCenter(), UiMiddle())
		UiAlign("center middle")
		UiImage("MOD/images/wlp.png")
	UiPop()

	--Files
	UiPush()
		local trsY = 0

		for i=1,#files do
			UiTranslate(25, 100)
			trsY=trsY+100

			UiAlign('left bottom')

			if UiImageButton('MOD/images/file.png') then
				windows[#windows+1]={render=Notepad, posX=500, posY=500, sizeX=500, sizeY=400, file=files[i]['name'], text=files[i]['content']}
			end

			UiTranslate(-25, 25)
			trsY=trsY+25

			UiAlign('left top')
			UiFont('regular.ttf', 25)
			UiText(files[i]['name'])

			if trsY + 125 >= UiHeight() - taskbarsize then
				UiTranslate(150, -trsY)	
				trsY = 0
			end
		end
	UiPop()

	WindowsDraw(td)
	ResizeDraw()
	ContextMenuDraw()

	--Taskbar
	UiPush()
		UiTranslate(0, UiHeight()-taskbarsize)
		SetTransparent(true, .7)
		h=UiHeight()
		UiWindow(UiWidth(), taskbarsize, true)
		if TaskbarBlur then UiBlur(BlurAmt) end
		UiImageBox('MOD/images/white.png', UiWidth(), taskbarsize, 6, 6)
		SetTransparent()
		TaskbarRender(h, td)
	UiPop()

	--Fullscreen message
	if msg~='' then
		if MsgBlur then UiBlur(BlurAmt) end
		SetTransparent(true,.9)
		UiTranslate(UiCenter(), UiMiddle())
		UiAlign("center middle")
		UiImageBox('MOD/images/white.png', UiWidth(), UiHeight(), 6, 6)
		UiFont('regular.ttf', 32)
		UiWordWrap(UiWidth()/4)
		SetTransparent()
		h,w=UiGetTextSize(msg)
		UiText(msg)
		UiTranslate(0, h/4)
		if UiTextButton('OK') then
			msg=''
		end
	end

	--OS info
	UiPush()
		UiTranslate(UiWidth(), UiHeight())
		UiAlign('right bottom')
		SetTransparent(false, .7)
		UiFont('regular.ttf', 16)
		if UiTextButton('Catto OS v0.1 beta') then
			msg=(
					'Catto OS is made by Lazy cat#2022.\n'..
					'You can contribute on GitHub to make this OS better.\n'..
					'github.com/Woolbex/CattoOS'
				)
		end
	UiPop()
end

function tick(td)
	SetBool("game.disablepause", true)
	SetBool("game.disablemap", true)

	if debug then
		x, y = UiGetMousePos()
		inp = GetInput() or GetInput(true)

		DebugWatch('X', x)
		DebugWatch('Y', y)

		DebugWatch('Attach X', dndAttachX)
		DebugWatch('Attach Y', dndAttachY)

		if inp then DebugWatch('Key', inp) end

		if selected and windows[selected] then
			DebugWatch('Pos X', windows[selected]['posX'])
			DebugWatch('Pos Y', windows[selected]['posY'])
	
			DebugWatch('Size X', windows[selected]['sizeX'])
			DebugWatch('Size Y', windows[selected]['sizeY'])
			
			DebugWatch('Full', windows[selected]['full'])
			DebugWatch('ID', selected)
		end

		DebugWatch('Last X', LastX)
		DebugWatch('Last Y', LastY)
		DebugWatch('Last time move', LastTimeMove)

		DebugWatch('Windows amount', #windows)
		DebugWatch('Windows data', windows)

		DebugWatch('Blur amount', BlurAmt)
		DebugWatch('Transparency multiplier', TrsMlt)

		DebugWatch('Taskbar selected', TaskbarSelected)
		DebugWatch('Files', #files)
	end

	SetBool('savegame.mod.TaskbarBlur', TaskbarBlur)
	SetBool('savegame.mod.WindowBlur', WindowBlur)
	SetBool('savegame.mod.MsgBlur', MsgBlur)
	SetBool('savegame.mod.ContextMenuBlur', ContextMenuBlur)
	SetBool('savegame.mod.SoftBlur', SoftBlur)
	SetBool('savegame.mod.EyeBurn', EyeBurn)
	SetBool('savegame.mod.MoreTrs', MoreTrs)
	SetBool('savegame.mod.SSE', SSE)
	SetBool('savegame.mod.STB', STB)

	if InputPressed('esc') then
		showLauncher, showContextMenu = false
		msg=''
	end

	maxWindowSize=UiHeight()-150
end