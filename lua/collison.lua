pinInput = 5--D5

pin=4 --D4

gpio.mode(pin,gpio.OUTPUT)
gpio.write(pin,gpio.LOW)

gpio.mode(pinInput,gpio.INPUT)

--while true do   --read and print accelero, gyro and temperature value
--
--    val = gpio.read(pinInput)
--
--    if val == gpio.LOW then
--        print("low HIT - collided")
--        gpio.write(pin,gpio.LOW)
--    else
--        print("high")
--        gpio.write(pin,gpio.HIGH)
--    end
--    tmr.delay(1000)
----    tmr.delay(1000 * 1000 * 2)   -- 100ms timer delay    
--end

called = false
mytimer = tmr.create()
-- 10 millseconds
idx = 0
mytimer:register(100, tmr.ALARM_AUTO, function()    
    local val = gpio.read(pinInput)
    local data = val == gpio.LOW
--    print(tostring(tmr.now()).." hey after 1 seconds") 
    --print("collided: ", tostring(data), 'called', tostring(called));
    if data  then
        called = true  
        callCount = 0      
        idx = idx + 1
        print("\n"..tostring(tmr.now())..' '..idx.."--------collided call");                
    else
        idx = 0    
    end 
end)
mytimer:start()
print("init")
