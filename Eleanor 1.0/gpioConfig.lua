gpio.mode(btResetPin,gpio.OUTPUT)
gpio.write(btResetPin,gpio.HIGH)

tmr.create():alarm(1000,tmr.ALARM_SINGLE,function()
	gpio.write(btResetPin,gpio.LOW)
end)


gpio.mode(statusLedPin,gpio.OUTPUT)
gpio.write(statusLedPin,gpio.HIGH)

uart.setup(1,115200,8,uart.PARITY_NONE,uart.STOPBITS_1,0)
uart.setup(0,115200,8,uart.PARITY_NONE,uart.STOPBITS_1,0)