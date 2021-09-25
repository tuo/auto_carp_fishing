dofile("sim800c_wrapped.lua")
dofile("mpu6050_wrapped.lua")

pin=4 --D4

gpio.mode(pin,gpio.OUTPUT)
gpio.write(pin, gpio.LOW)

tmr.delay(3 * 1000 * 1000) --delay 10 seconds

sim_setup()

gpio.write(pin, gpio.HIGH)

tmr.delay(1000 * 1000)
mpu6050_setup();

tmr.delay(1000 * 1000)

AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ = mpu6050_read()

INITIAL_ACCEL_X = AccelX

data = string.format("Ax:%.3g,Ay:%.3g,Az:%.3g,T:%.3g,Gx:%.3g,Gy:%.3g,Gz:%.3g",
                        AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ)

sim_send("init:"..data)

tmr.delay(1000 * 1000)
print("all done, kick off loop", INITIAL_ACCEL_X);

gpio.write(pin, gpio.LOW)


counter = 0
called = false
shouldCall = false
mytimer = tmr.create()
mytimer:register(30 *1000, tmr.ALARM_AUTO, function()    
    AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ = mpu6050_read()
    data = string.format("Ax:%.3g,Ay:%.3g,Az:%.3g,T:%.3g,Gx:%.3g,Gy:%.3g,Gz:%.3g",
                        AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ)
    print("after 20"..data..tostring(shouldCall));
    if called == true and shouldCall == false then
        print("should call phone");        
        shouldCall = true;     
        sim_call()
        -- reset after 1 minutes
        
    else
        sim_send(counter..'-'..data..'-('..(string.format('%.2f', gap))..')'..tostring(shouldCall))    
    end 
    
    gpio.write(pin, gpio.HIGH)
    counter = counter+1
    if counter == 30 then        
        mytimer:interval(30 * 1000); 
    end
end)
mytimer:start()



-- every second, check offset 
mytimer_alert = tmr.create()
mytimer_alert:register(1 *1000, tmr.ALARM_AUTO, function()    
    AccelX, AccelY, AccelZ, Temperature, GyroX, GyroY, GyroZ = mpu6050_read()
    gap = INITIAL_ACCEL_X - AccelX
    print("gap", AccelX, INITIAL_ACCEL_X, gap, math.abs(gap));
    if math.abs(gap) > 0.2 and called == false then
        called = true        
        print("--------call");        
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
