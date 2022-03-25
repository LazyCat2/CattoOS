function Test(windowData)
	UiTranslate(UiCenter(), UiMiddle())
	UiAlign('center middle')
	UiFont('regular.ttf', 32)
	t='Window #'..windowData['id']..'\n'
	if windowData['full'] then
		t=t..'Fullscreen\n'
	else
		t=t..'Windowed\n'
	end
	if windowData['active'] then
		t=t..'Active'
	else
		t=t..'Not active'
	end
	UiText(t)
end
