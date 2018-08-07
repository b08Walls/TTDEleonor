
local btCallBack = assert(loadfile('bluetoothCallback.lua'))()
local btTimer = tmr.create()
local btTries = 0
local btReboots = 0
local resultado = nil
local status = 0

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
	
	assert(loadstring(btExe))(btTimer)

	if btReboots > 3 then
		node.restart()
	end
end)

uart.on("data",0,
	function(text)
		resultado, status = btCallBack(text)
		if resultado and status == 1 then 
			btTimer:stop()
			btReady = true
			assert(loadfile('mqttMessenger.lua'))("tugger",resultado)
		elseif status == -1 then
			btReady = true
			btTimer:stop()
		end
		assert(loadstring(btExe))(btTimer)
	end,0)

--First a request is sent to the bluetooth:
btExe = [[
	local btTimer = ...
	if btReady then 
		btReady = false
		uart.write(1,"AT+DISI?") 
		btTimer:start()
		print("timer iniciado")
	end
]]

assert(loadstring(btExe))(btTimer)