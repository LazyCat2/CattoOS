function ContextMenuDraw()
	if InputPressed('rmb') and contextMenu then
		ContextMenuX=x
		ContextMenuY=y
		showContextMenu = true
	end
	if msg~='' or InputPressed('lmb') and not (
			NumInRange(x, ContextMenuX, ContextMenuSizeX+ContextMenuX) and
			NumInRange(y, ContextMenuY, ContextMenuSizeY+ContextMenuY)
		) 
	then
		showContextMenu=false
	end
	if showContextMenu then
		UiPush()
			SetTransparent(true,.7)
			UiAlign('left top')
			UiTranslate(ContextMenuX, ContextMenuY)
			UiWindow(ContextMenuSizeX, ContextMenuSizeY, true)

			if ContextMenuBlur then UiBlur(BlurAmt) end

			UiImageBox('MOD/images/white.png', ContextMenuSizeX, ContextMenuSizeY, 6, 6)
			SetTransparent()
			UiFont('regular.ttf', 32)

			offset=30
			crfile = UiTextButton('Create file')

			if crfile then
				Write('File #'..#files+1 ..'.txt', '')
			end
			
			UiTranslate(0,offset)
			clswnd = UiTextButton('Close all windows')

			if clswnd then
				windows={}
			end

			UiTranslate(0,offset)
			minwnd=UiTextButton('Minimize all windows')

			if minwnd then
				for i=1,#windows do
					windows[i]['min']=true
				end
			end

			UiTranslate(0, offset)
			maxwnd=UiTextButton('Maximize all windows')

			if maxwnd then
				for i=1,#windows do
					windows[i]['min']=false
				end
			end

			if crfile or clswnd or minwnd or maxwnd then
				showContextMenu = false
			end
		UiPop()
	end
end