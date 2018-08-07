
dofile('constants.lua')
dofile('gpioConfig.lua')
dofile('wifiManager.lua')

bluetoothCallback = assert(loadfile('bluetoothCallback.lua'))()
mqttMessenger = assert(loadfile('mqttMessenger.lua'))

assert(loadfile("bluetoothQuery.lua"))(bluetoothCallback,mqttMessenger)

