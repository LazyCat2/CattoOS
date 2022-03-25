function Settings(windowData)
	UiFont('regular.ttf', 32)
	UiAlign('left bottom')
	UiPush()
		offset=40 UiTranslate(0, offset)

		if TaskbarBlur then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end

		if UiTextButton('Taskbar blur') then
			TaskbarBlur=not TaskbarBlur
		end UiTranslate(0, offset) 

		if WindowBlur then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end

		if UiTextButton('Window blur') then
			WindowBlur=not WindowBlur
		end UiTranslate(0, offset) 

		if MsgBlur then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end

		if UiTextButton('FS msg blur') then
			MsgBlur=not MsgBlur
		end UiTranslate(0, offset) 

		if ContextMenuBlur then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end

		if UiTextButton('Context menu blur') then
			ContextMenuBlur=not ContextMenuBlur
		end UiTranslate(0, offset) 

		if SoftBlur then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end 

		if UiTextButton('Soft blur') then
			SoftBlur=not SoftBlur
		end UiTranslate(0, offset)

		if EyeBurn then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end 

		if UiTextButton('Eye burn mode') then
			EyeBurn=not EyeBurn
		end UiTranslate(0, offset)

		if MoreTrs then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end 

		if UiTextButton('More transparent') then
			MoreTrs=not MoreTrs
		end UiTranslate(0, offset)

		if SSE then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end 

		if UiTextButton('Screen saver') then
			SSE = not SSE
		end UiTranslate(0, offset)

		if STB then UiFont('bold.ttf', 32)
		else UiFont('regular.ttf', 32) end 

		if UiTextButton('Small taskbar') then
			STB = not STB
		end UiTranslate(0, offset)

	UiPop()
	UiTranslate(UiCenter(), UiHeight()-50)
	UiAlign('center top')
end