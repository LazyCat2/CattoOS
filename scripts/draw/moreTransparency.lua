function MoreTransparentDraw(td)
	if MoreTrs then
		if TrsMlt > 0.5 then
			TrsMlt = TrsMlt - td
		end

		if TrsMlt < 0.5 then
			TrsMlt=0.5
		end
	else
		if TrsMlt < 1 then
			TrsMlt = TrsMlt + td
		end
		
		if TrsMlt > 1 then
			TrsMlt=1
		end
	end
end