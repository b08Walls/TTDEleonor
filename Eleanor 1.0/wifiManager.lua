
wifiTestWeb = 'http://10.42.0.1:5001/connTest?chipid='..node.chipid()

wifi.setmode(wifi.STATION)
wifi.setphymode(wifi.PHYMODE_B)
local stationConfig = {}
stationConfig.ssid = "TUGGER-NET"
stationConfig.pwd = "1L0V3TUGG3R"
wifi.sta.config(stationConfig)

local ipConfig = {}
ipConfig.ip = "192.168.0.42"
ipConfig.netmask = "255.255.255.0"
ipConfig.gateway = "192.168.0.1"
ipConfig.auto = true
ipConfig.save = true
wifi.sta.setip(ipConfig)

local wifiCounter = 0;

print("WIFI READY")

local wifiTimer = tmr.create()
wifiTimer:register(10000,tmr.ALARM_AUTO,function()
	http.get(wifiTestWeb,nil,function(code,data)
		if code < 0 then
			wifiCounter = wifiCounter+1
			if wifiCounter > 3 then
				node.restart()
			end
		else
			wifiReady = true
		end
	end)
end)

local ledTimer = tmr.create()
ledTimer:register(250,tmr.ALARM_AUTO,function()
	gpio.write(3,not(gpio.read(3) == 0) and 0 or 1)
	end)

print("wifiTimer crearted")


wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
	print("TODO CONECTADO")
	ledTimer:stop()
	gpio.write(3,gpio.HIGH)
	http.get(wifiTestWeb,nil,function(code,data)
		if code < 0 then
			wifiCounter = wifiCounter+1
			print("wifiCounter",wifiCounter)
			if wifiCounter > 3 then
				node.restart()
			end
		else
			wifiReady = true
		end
	end)
	wifiTimer:start()
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
	print("SE DESCONECTO.........",T.reason)
	ledTimer:start()
	if wifiTimer then
		wifiTimer:stop()
	end

	wifiReady = false
	
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
