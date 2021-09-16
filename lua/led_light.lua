light=0

pin=4 --D4

gpio.mode(pin,gpio.OUTPUT)
gpio.write(pin,gpio.HIGH)
print("initial turn off light");
-- -lua语言基础语法 https://www.cnblogs.com/yifengs/p/14544867.html
--  定时器： https://nodemcu.readthedocs.io/en/release/modules/tmr/#tobjalarm
-- https://www.engineersgarage.com/getting-started-with-the-esplorer-ide/
if not tmr.create():alarm(2000, tmr.ALARM_AUTO, function()
  print("looping - light switch:", light)
  if light==0 
  then
    light=1
    gpio.write(pin,gpio.LOW)
  else
    light=0
    gpio.write(pin, gpio.HIGH)
  end
end)  
then
  print("whoopsie, error when create tmr")
end

--[[
tmr.alarm(1,1000,1,function()

    if light==0 then
    
        light=1
    
        gpio.write(pin,gpio.HIGH)
    
    else
    
        light=0
    
        gpio.write(pin,gpio.LOW)
    
    end

end)
--]]
