function ScreenSaverDraw(td)
	if 
		(x ~= LastX) or 
		(y ~= LastY) or 
		InputPressed("any")
	then
		LastTimeMove=0
		ScreenSaver=false
		LastX=x LastY=y
	else
		LastTimeMove=LastTimeMove+td
	end

	if LastTimeMove > 10 then
		ScreenSaver=true
		LastTimeMove=11
	end

	if ScreenSaver then
		SetTransparent(true)
		UiImageBox('MOD/images/white.png', UiWidth(), UiHeight())
		UiColor(1,1,1)
		speed=5
		if LogoMoveX then LogoX=LogoX+speed else LogoX=LogoX-speed end
		if LogoMoveY then LogoY=LogoY+speed else LogoY=LogoY-speed end
	
		if LogoX <= 0 then LogoMoveX = true end
		if LogoX >= UiWidth()-75 then LogoMoveX = false end
	
		if LogoY <= 0 then LogoMoveY = true end
		if LogoY >= UiHeight()-75 then LogoMoveY = false end

		UiTranslate(LogoX, LogoY)
		UiImage('MOD/images/logo.png')
	end
end