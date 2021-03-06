
local topic,message = ...
print("---------------------------------------------")
print("Topico: ",topic,"Mensaje:",message)
print("---------------------------------------------")

local toExe = nil
local connected = false
if type(message) == 'string' then
	toExe = assert(loadstring([[
		local _topic, _message, client = ...

		local _ok, _jsonMessage = pcall(sjson.encode, _message)
		if _ok then
			print("about to send..",_topic,_jsonMessage)
  			client:publish(_topic,_jsonMessage, 0, 0, function(client) print("sent") end)
		else
			print("failed to encode!")
		end

		]]))
elseif type(message == 'table') then
	toExe = assert(loadstring([[
		local _topic, _message, client = ...
		local sentMessages = 0

		for k,v in pairs(_message) do

			local _ok, _jsonMessage = pcall(sjson.encode, v)
			if _ok then
				print("about to send..",_topic,_jsonMessage)
				client:publish(_topic,_jsonMessage,0,0,function(client) 
													print("sent") 
													sentMessages = sentMessages+1
													if sentMessages == #_message then
													end
												end)
			else
				print("failed to encode!")
			end

		end
		]]))
end



-- init mqtt client without logins, keepalive timer 120s
m = mqtt.Client("clientid"..node.chipid(), 120)

-- to topic "/lwt" if client don't send keepalive packet

local offlineList = {}
offlineList.offline = node.chipid()
offlineList.chipid = node.chipid()

local ok, offlineJSON = pcall(sjson.encode,offlineList)
local lwString = ""

if ok then
	lwString = offlineJSON
else
	lwString = offline..node.chipid()
end


m:lwt("lwt", lwString, 0, 0)
m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") connected = false end)

-- for TLS: m:connect("192.168.11.118", secure-port, 1)
if not connected then
	m:connect("10.42.0.1", 1883, 0, function(client)
	print("connected")
	connected = true
	if message and topic and toExe then
		local onlineList = {}
		onlineList.online = node.chipid()
		onlineList.chipid = node.chipid()
		local _ok, onlineJSON = pcall(sjson.encode,onlineList)
		print(_ok)
		if _ok then
			print("REGISTER MESSAGE!")
			client:publish('node/register',onlineJSON,0,0,function(client) print("register, done!") end)
		end
		toExe(topic,message,client)
	end
	end,
	function(client, reason)
	print("failed reason: " .. reason)
	end)
else
	if message and topic and toExe then
		toExe(topic,message,m)
	end
end

