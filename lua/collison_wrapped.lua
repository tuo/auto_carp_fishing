pinInput = 5--D5
gpio.mode(pinInput,gpio.INPUT)



function collison_read_if_collided()
    local val = gpio.read(pinInput)
    return val == gpio.LOW
end

--
--while true do   --read and print accelero, gyro and temperature value
--
--    val = gpio.read(pinInput)
--
--    if val == gpio.LOW then
--        print("low HIT - collided")
----        gpio.write(pin,gpio.LOW)
--    else
--        print("high")
----        gpio.write(pin,gpio.HIGH)
--    end
--    tmr.delay(1000)
----    tmr.delay(1000 * 1000 * 2)   -- 100ms timer delay    
--end
