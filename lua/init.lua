dofile("sim800c_wrapped.lua")
dofile("mpu6050_wrapped.lua")

tmr.delay(10 * 1000 * 1000) --delay 10 seconds

sim_setup()



tmr.delay(1000 * 1000)
mpu6050_setup();

tmr.delay(1000 * 1000)

data = mpu6050_read()
sim_send("init:"..data)

print("all done, kick off loop");

mytimer = tmr.create()
mytimer:register(20000, tmr.ALARM_AUTO, function() 
    data = mpu6050_read()
    print("after 20"..data);
    sim_send("after20: "..data)
end)
mytimer:start()
--
--
--mytimer2 = tmr.create()
--mytimer2:register(20000, tmr.ALARM_SINGLE, function() 
--    print("hey after 20 seconds") 
--    sim_send("after20")
--end)
--mytimer2:start()
--dofile("led_light.lua")
