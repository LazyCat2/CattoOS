function Notepad(windowData)
	text = windowData['text'] or ''
	file = windowData['file'] or "File #"..#files+1 ..".txt"

	if windowData['active'] then
		inp = GetInput()
		if inp and not InputDown('ctrl') then text=text..inp end
		if InputPressed('return') then text=text..'\n' end
	end

	UiFont('regular.ttf', 32)

	UiPush()
		UiAlign('left top')
		UiText(file)
	UiPop()
	UiAlign('center middle')
	UiTranslate(UiCenter(), UiMiddle())
	UiWordWrap(windowData['sizeX'])
	UiText(text)
	UiTranslate(0, UiMiddle()-50)
	if UiTextButton('SAVE') or (InputDown('ctrl') and InputDown('s')) then
		Write(file, text)
	end

	windows[windowData['id']]['text'] = text
	windows[windowData['id']]['file'] = file
end