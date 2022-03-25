function TaskbarRender(h, td)
	TaskbarSelected=0
	UiColor(1,1,1)
	UiFont('regular.ttf', 32)
	if STB then
		if taskbarsize > 50 then
			taskbarsize = taskbarsize - td*100
		end
	
		if taskbarsize < 50 then
			taskbarsize=50
		end
	else
		if taskbarsize < 100 then
			taskbarsize = taskbarsize + td*100
		end
		
		if taskbarsize > 100 then
			taskbarsize=100
		end
	end

	UiImageBox('MOD/images/logo.png', taskbarsize, taskbarsize, 1, 1, 1)
	UiTranslate(taskbarsize, 0)
	if showLauncher then
		for i=1,#apps do
			UiImageBox('MOD/images/'..apps[i]['icon'], taskbarsize, taskbarsize)
			UiTranslate(taskbarsize, 0)
		end
	else
		for i=1,#windows do
			if windows[i] then
				for o=1,#apps do
					if apps[o]['program']==windows[i]['render'] then
						if windows[i]['min'] then
							it=0.5*TrsMlt
						else
							it=1
						end

						UiColor(1, 1, 1, it)
						UiImageBox('MOD/images/'..apps[o]['icon'], taskbarsize, taskbarsize)
						UiTranslate(taskbarsize)

					end
				end
			end
		end
	end

	if InputPressed('lmb') and x < taskbarsize and y > h-taskbarsize then
		showLauncher=not showLauncher
	end

	if x > taskbarsize and y > h-taskbarsize then
		if showLauncher then
			local target=0
			for i=1,#apps do
				target=i*taskbarsize
				if NumInRange(x, target, target+taskbarsize) then
					if InputPressed('lmb') then
						windows[#windows+1]={render=apps[i]['program'], posX=500, posY=500, sizeX=500, sizeY=500}
						showLauncher=false
					else
						UiPush()
							UiTranslate(#apps*(taskbarsize/(#apps/2)), UiMiddle())
							UiAlign('center middle')
							UiText(apps[i]['name'])
						UiPop()
					end
				end
			end
		else
			local target=0
			for i=1,#windows do
				target=i*taskbarsize
				if NumInRange(x, target, target+taskbarsize) then
					TaskbarSelected=i
				end
			end
	
			if TaskbarSelected ~= 0 then
				if InputPressed('lmb') then
					windows[TaskbarSelected]['min']=not windows[TaskbarSelected]['min']
					windows[TaskbarSelected]['full']=false
				else
					for i=1,#apps do
						if apps[i]['program']==windows[TaskbarSelected]['render'] then
							UiPush()
								UiTranslate(#windows*(taskbarsize/(#windows/2)), UiMiddle())
								UiAlign('center middle')
								UiText(apps[i]['name'])
							UiPop()
						end
					end
				end
			end
		end
	elseif InputPressed('lmb') and y < h-taskbarsize then
		showLauncher=false
	end
end