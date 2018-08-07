

local contador = (function()
	local cuenta = 0

	local function masUno()
		cuenta = cuenta+1
		print(cuenta)
		end

	return masUno
	end)()


contador()
contador()
contador()
contador()
contador()
contador()
contador()