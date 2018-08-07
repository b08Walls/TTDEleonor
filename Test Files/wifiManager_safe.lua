
wifiTestWeb = 'http://10.42.0.1:5001/connTest'

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
	print("TODO CONECTADO")
	wifiTimer:start()
	end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
	print("SE DESCONECTO.........",T.reason)
	wifiTimer:stop()
	wifi.sta.connect()
	
	if T.reason == 2 then
		wifi.sta.getap(function(t)
			for k,v in pairs(t) do
				print(k,v)
			end
		end)
		-- for k,v in pairs(wifi.sta.getap()) do print(k,v) end
		print("conectando....")
	end
	print(wifi.sta.getip())
	end)



wifi.setmode(wifi.STATION)
wifi.setphymode(wifi.PHYMODE_B)
local stationConfig = {}
stationConfig.ssid = "TUGGER-NET"
stationConfig.pwd = "1L0V3TUGG3R"
wifi.sta.config(stationConfig)

local ipConfig = {}
ipConfig.ip = "192.168.0.10"
ipConfig.netmask = "255.255.255.0"
ipConfig.gateway = "192.168.0.1"
ipConfig.auto = true
ipConfig.save = true
wifi.sta.setip(ipConfig)

print("WIFI READY")

local wifiTimer = tmr.create()
wifiTimer:register(5000,tmr.ALARM_AUTO,function()
	http.get(wifiTestWeb,nil,function(code,data)
			if code < 0 then
			else
				print(code,data)
			end
		end)
	end)

print("wifiTimer crearted")

