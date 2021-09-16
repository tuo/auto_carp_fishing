--setup wifi

wifi.setmode(wifi.STATIONAP)
wifi.sta.config("ziroom", "qwer1122")
wifi.sta.connect()

mytimer = tmr.create()
mytimer.register(2000, tmr.ALARM_AUTO, function()
  print("looping - light switch:", light)
  if wifi.sta.getip() == nil then
    print("connecting...");
  else mytimer.stop()
    print("connected,Ip is "..wifi.sta.getip()) --得到的是nodemcu的IP，后面客户端要连接的就是这个地址
  end
end)  
mytimer.start()



pin=4 --D4
gpio.mode(pin,gpio.OUTPUT)

