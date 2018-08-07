
local btCallBack,mqttMessenger = ...
local btTimer = tmr.create()
local btTries = 0
local btReboots = 0
local resultado = nil
local status = 0

btExe = [[
	local btTimer = ...
	if btReady then 
		btReady = false
		uart.write(1,"AT+DISI?") 
		btTimer:start()
		print("timer iniciado")
	end
]]

btTimer:register(5000,tmr.ALARM_SEMI,function()
	print("no response")
	btReady = true
	btTries = btTries+1
	print("btTries",btTries)
	if btTries > 3 then
		btTries = 0
		btReboots = btReboots+1
		print("BT OFF...")
		gpio.write(btResetPin,gpio.HIGH)
		tmr.create():alarm(1000, tmr.ALARM_SINGLE, function()
			print("BT ON...")
  			gpio.write(btResetPin,gpio.LOW)
		end)
	end
	
	print("SOLICITANDO NUEVAMENTE DESDE TIMER")
	assert(loadstring(btExe))(btTimer)

	if btReboots > 3 then
		node.restart()
	end
end)

uart.on("data",0,
	function(text)
		resultado, status = btCallBack(text)
		if resultado and status == 1 then 
			print("RESULTADO CORRECTO Y ENVIANDO")
			btTimer:stop()
			btReady = true
			print("****************************************")
			print("wifiReady:",wifiReady)
			print("****************************************")
			if wifiReady then
				mqttMessenger("tugger"..node.chipid(),resultado)
				mqttMessenger("tugger",resultado)
			end
			assert(loadstring(btExe))(btTimer)
		elseif status == -1 then
			print("RESULTADO VACIO Y SOLICITANDO")
			btReady = true
			btTimer:stop()
			assert(loadstring(btExe))(btTimer)
		end
	end,0)

--First a request is sent to the bluetooth:

print("PRIMERA LLAMADA DE BLUETOOTHQUERY")
assert(loadstring(btExe))(btTimer)