function SoftBlurDraw(td)
	if SoftBlur then
		if BlurAmt > 0.5 then
			BlurAmt = BlurAmt - td
		end

		if BlurAmt < 0.5 then
			BlurAmt=0.5
		end
	else
		if BlurAmt < 1 then
			BlurAmt = BlurAmt + td
		end
		
		if BlurAmt > 1 then
			BlurAmt=1
		end
	end
end