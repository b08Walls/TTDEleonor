local buffer = ""

print("SE MANDA A LLAMAR CREATE BLUETOOTH CALLBACK")
return (function(data)
	
	-- print("String recibido en data",data)

	if data then
		
		buffer = buffer..data
		-- print("BUFER ES: ",buffer)
		
		if buffer:find("quit") then
			print("UART CALLBACK UN REGISTERED!")
			file.remove("init.lua")
			uart.on("data")
			node.restart()
		end

		if buffer:find("OK+DISISOK+DISCE") then
			print("NO BEACONS")
			buffer = ""
			return nil, -1
		end

		-- ........................NOW WE LOOK FOR VALUES...........

		local s,e = buffer:find("OK%+DISIS[%a%d%p%x]+OK%+DISCE")
		local beaconData = {}

		if s and e then

			for word in buffer:gmatch("%+DISC:[%a%d%p]-OK") do

				local valores = word:gsub("+DISC",""):gsub("OK",":")
				local _beaconData = {}
				local index = 1

				_beaconData.chipid = node.chipid()

				for valor in valores:gmatch("[%-%a%d]+") do

					if index == 2 then
						_beaconData.UUID = valor
					elseif index == 3 then
						_beaconData.maxLoad = valor:sub(1,4)
						_beaconData.minLoad = valor:sub(5,8)
						_beaconData.txPower = valor:sub(9,10)
					elseif index == 5 then
						_beaconData.signal = valor
						_beaconData.distancia = 10^((-57-tonumber(valor))/20)
					end
					index = index+1
				end--TERMINA FOR QUE RECORRE LOS VALORES DE CADA BEACON

				if _beaconData.UUID ~= '00000000000000000000000000000000' then
					beaconData[#beaconData+1] = _beaconData
				end
				--print("se agrego",_beaconData)
				--for k,v in pairs(_beaconData) do print(k,v) end
			end--TERMINA EL FOR QUE RECORRE CADA BEACON

			print("------------------------------------------------------------")
			print("SE VA A RETORNAR beaconData DE LONGITUD: ",#beaconData)
			buffer = ""
			if #beaconData > 0 then
				for i,j in pairs(beaconData) do 
					print(i,j)
				end
				print("------------------------------------------------------------")
				return beaconData, 1
			else
				return nil,-1
			end
		else
			-- print("No text")
			return nil, 0
		end--Termina if de busqueda
	end-- Termina if de data
end)--Termina funcion anonima a retornar.








