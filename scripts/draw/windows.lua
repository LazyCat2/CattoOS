function WindowsDraw(td)
	if windows ~= {} then
		useDND=TaskbarSelected==0 
		contextMenu=NumInRange(y, 0, UiHeight()-taskbarsize) 
		vbn=true

		for i=1,#windows do
			if windows[i] then 
				if windows[i]['full'] then 
					vbn = false 
				end 

				if windows[i]['dnd'] then
					useDND = false
				end
			end

		end
		for i=1,#windows do
			if windows[i] then
				if windows[i]['full'] then
					sizeX = UiWidth()
					sizeY = UiHeight()-taskbarsize
				else
					sizeX = windows[i]['sizeX']
					sizeY = windows[i]['sizeY']
				end

				UiPush()
				windows[i]['posX'] = min(
						max(windows[i]['posX'], 0),
						UiWidth()-sizeX
					)
				windows[i]['posY'] = min(
						max(windows[i]['posY'], 0),
						UiHeight()-sizeY-taskbarsize
					)


					if not windows[i]['full'] then UiTranslate(windows[i]['posX'], windows[i]['posY']) end
					active = ((NumInRange( --Cursor on window
								x, windows[i]['posX'],
								windows[i]['posX']+sizeX
							) and NumInRange(
								y, windows[i]['posY'],
								windows[i]['posY']+sizeY
							)) or TaskbarSelected==i) and 
							msg == '' and --no FS msg
						(vbn or windows[i]['full']) and --no FS windows or current window is FS
						not windows[i]['min'] --Window is not minimized

					if (active and useDND) or windows[i]['dnd'] then
							windows[i]['dnd']=InputDown('lmb')
							useDND=false
							if InputPressed('lmb') then
								dndAttachX=windows[i]['posX']-x
								dndAttachY=windows[i]['posY']-y
							elseif InputDown('lmb') then
								windows[i]['posX'] = dndAttachX+x
								windows[i]['posY'] = dndAttachY+y
							end
						end

					if active then 
						contextMenu=false
						selected=i 

						if InputPressed('F6') then
							windows[i]['full']=(not windows[i]['full']) and vbn
						end

						if InputDown('ALT') and InputDown('F4') then
							windows[i]['close'] = true
						end

						SetTransparent(true, .9) 
					else 
						SetTransparent(true, .5) 
					end
					
					
					if (windows[i]['min'] and TaskbarSelected~=i) or (not (vbn or windows[i]['full'])) or ScreenSaver then UiWindow(0, 0, true)
					else UiWindow(sizeX, sizeY, true) end
					if windows[i]['min'] and TaskbarSelected==i then
						SetTransparent(true, .2)
					end
					if WindowBlur then UiBlur(BlurAmt) end
					UiImageBox('MOD/images/white.png', sizeX, sizeY, 6, 6)
					SetTransparent()
					
					data = windows[i]
					data['id'] = i
					data['active']=active and not (resizeMode or TaskbarSelected>0)
					windows[i]['render'](data, td)
				UiPop()
			end
		end
	end
	windows=Remove(windows)
end