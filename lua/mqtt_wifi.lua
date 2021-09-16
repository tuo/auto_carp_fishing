


function startup()
   print("wifi is ready at "..wifi.sta.getip());
       -- init mqtt client with logins, keepalive timer 120sec
    m = mqtt.Client("device1", 120, "thingidp@apagspq|device1|0|MD5", "")
    
    -- setup Last Will and Testament (optional)
    -- Broker will publish a message with qos = 0, retain = 0, data = "offline"
    -- to topic "/lwt" if client don't send keepalive packet
    m:lwt("/lwt", "offline", 0, 0)
    
    m:on("offline", function(client) print ("offline") end)
    
    -- on publish message receive event
    m:on("message", function(client, topic, data)
      print("onMessageRec - topic: ", topic )
      if data ~= nil then
        print("onMessageRec - data: ", data)
      end
    end)
    
    -- on publish overflow receive event
    m:on("overflow", function(client, topic, data)
      print(topic .. " partial overflowed message: " .. data )
    end)
    
    -- for TLS: m:connect("192.168.11.118", secure-port, 1)
    m:connect("apagspq.iot.gz.baidubce.com", 1883, false, function(client)
      print("connected")
      -- Calling subscribe/publish only makes sense once the connection
      -- was successfully established. You can do that either here in the
      -- 'connect' callback or you need to otherwise make sure the
      -- connection was established (e.g. tracking connection status or in
      -- m:on("connect", function)).
    
      -- subscribe topic with qos = 0
      client:subscribe("$iot/device1/user/fortest", 0, function(client) print("subscribe success") end)
      -- publish a message with data = hello, QoS = 0, retain = 0

      local raw_payload = string.format("温度:%f, 湿度:%d - %s", 33.01, 49, "合适")
       
      print("raw_payload", raw_payload)
      client:publish("$iot/device1/user/fortest", raw_payload, 0, 0, function(client) print("sent") end)
    end,
    function(client, reason)
      print("Connection failed reason: " .. reason)
    end)
    
    m:close()
    -- you can call m:connect again after the offline callback fires 
   
end

-- Define WiFi station event callbacks
wifi_connect_event = function(T)
  print("Connection to AP("..T.SSID..") established!")
  print("Waiting for IP address...")
  if disconnect_ct ~= nil then disconnect_ct = nil end
end

wifi_got_ip_event = function(T)
  -- Note: Having an IP address does not mean there is internet access!
  -- Internet connectivity can be determined with net.dns.resolve().
  print("Wifi connection is ready! IP address is: "..T.IP)
  print("Startup will resume momentarily, you have 3 seconds to abort.")
  print("Waiting...")
  tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
end

wifi_disconnect_event = function(T)
  if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
    --the station has disassociated from a previously connected AP
    return
  end
  -- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
  local total_tries = 75
  print("\nWiFi connection to AP("..T.SSID..") has failed!")

  --There are many possible disconnect reasons, the following iterates through
  --the list and returns the string corresponding to the disconnect reason.
  for key,val in pairs(wifi.eventmon.reason) do
    if val == T.reason then
      print("Disconnect reason: "..val.."("..key..")")
      break
    end
  end

  if disconnect_ct == nil then
    disconnect_ct = 1
  else
    disconnect_ct = disconnect_ct + 1
  end
  if disconnect_ct < total_tries then
    print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
  else
    wifi.sta.disconnect()
    print("Aborting connection to AP!")
    disconnect_ct = nil
  end
end

-- Register WiFi Station event callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)

print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATIONAP)
wifi.sta.config({ssid="ziroom", pwd="qwer1122"})
-- wifi.sta.connect() not necessary because config() uses auto-connect=true by default


