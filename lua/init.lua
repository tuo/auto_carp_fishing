dofile("sim800c_wrapped.lua")
dofile("collison_wrapped.lua")

pin=4 --D4

gpio.mode(pin,gpio.OUTPUT)
gpio.write(pin, gpio.LOW)

tmr.delay(3 * 1000 * 1000) --delay 3 seconds

sim_setup()

gpio.write(pin, gpio.HIGH)


data = collison_read_if_collided()
sim_send("init colided:"..tostring(data))

tmr.delay(1000 * 1000) -- 1 seconds
print("all done, kick off loop");

gpio.write(pin, gpio.LOW)


counter = 0
called = false
shouldCall = false

mytimer = tmr.create()

callCount = 0
mytimer:register(10 *1000, tmr.ALARM_AUTO, function()        
    print("after 20"..tostring(data)..tostring(shouldCall));
    if called == true and shouldCall == false then
        print("should call phone now, after 2.5 min and 5 min");        
        if callCount == 0 or callCount == 5 or callCount == 15 then 
            sim_call()
        else
            sim_hangoff()            
            sim_send(counter..',collided='..tostring(true))    
        end
        if callCount == 15 then
            shouldCall = true            
        end 
        callCount = callCount+1
        -- reset
--        if callCount == 17 then
--            called = false            
--            callCount = 0
--        end 
        
        
        -- reset after 1 minutes
        gpio.write(pin, gpio.LOW)
    else
        sim_send(counter..',collided='..tostring(data)) 
        gpio.write(pin, gpio.HIGH)   
    end 
    
    gpio.write(pin, gpio.HIGH)
    counter = counter+1
    if counter == 30 then        
        mytimer:interval(30 * 1000); 
    end
end)
mytimer:start()



-- every milli second, check offset 
mytimer_alert = tmr.create()
-- 20 millseconds (best with 10 milli - hihger accuracy)
mytimer_alert:register(20, tmr.ALARM_AUTO, function()    
    data = collison_read_if_collided()
    --print("collided: ", tostring(data), 'called', tostring(called));
    if data and called == false then
        called = true  
        callCount = 0              
        print("--------collided call");        
    end 
end)
mytimer_alert:start()

--
--
--mytimer2 = tmr.create()
--mytimer2:register(20000, tmr.ALARM_SINGLE, function() 
--    print("hey after 20 seconds") 
--    sim_send("after20")
--end)
--mytimer2:start()
--dofile("led_light.lua")
