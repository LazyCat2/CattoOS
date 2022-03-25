function Time(windowData, td)
	UiFont('regular.ttf', 32)
	UiTranslate(UiCenter(), UiMiddle())
	UiAlign('center middle')

	local timer = windowData['timer'] or ''
	local run = windowData['run'] or false
	local num={ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}

	if timer ~= '' then
		UiText(timer)
	else
		UiText('Enter time in seconds then press enter')
	end
	
	if run then
		timer=timer-td
	end

	if InputPressed('return') and timer then
		run=true
	end

	if windowData['active'] then
		for i=1,#num do
			if InputPressed(num[i]) then
				timer=timer..num[i]
			end
		end
	end

	if timer ~= '' and timer+0 <= 0 then
		timer=''
		run=false
	end


	UiTranslate(0, UiMiddle()-50)

	windows[windowData['id']]['timer'] = timer
	windows[windowData['id']]['run'] = run
end