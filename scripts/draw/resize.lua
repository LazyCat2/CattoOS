function ResizeDraw()
	if InputPressed('F5') then resizeMode=not resizeMode end
	if resizeMode then
		UiPush()
			UiTranslate(x+15, y+15)
			UiImage('MOD/images/resize.png')
		UiPop()
		if selected then
			speed=1
			if InputDown('SHIFT') then
				speed=5
			end
			if InputDown('W') then
				windows[selected]['sizeY']=max(windows[selected]['sizeY']-speed, minWindowSize)
			end

			if InputDown('S') then
				windows[selected]['sizeY']=min(windows[selected]['sizeY']+speed, maxWindowSize)
			end

			if InputDown('A') then
				windows[selected]['sizeX']=max(windows[selected]['sizeX']-speed, minWindowSize)
			end

			if InputDown('D') then
				windows[selected]['sizeX']=min(windows[selected]['sizeX']+speed, maxWindowSize)
			end
		end
	end
end