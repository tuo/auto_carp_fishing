dofile("sim800c_wrapped.lua")



sim_setup()

tmr.delay(1000 * 1000) --delay one seconds
sim_send("init")
--
--
mytimer = tmr.create()
mytimer:register(20000, tmr.ALARM_AUTO, function() 
    print("hey after 20 seconds") 
    sim_send("after20")
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
