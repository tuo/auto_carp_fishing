pinInput = 5--D5

pin=4 --D4

gpio.mode(pin,gpio.OUTPUT)
gpio.write(pin,gpio.LOW)

gpio.mode(pinInput,gpio.INPUT)

while true do   --read and print accelero, gyro and temperature value

    val = gpio.read(pinInput)

    if val == gpio.LOW then
        print("low HIT - collided")
        gpio.write(pin,gpio.LOW)
    else
        print("high")
        gpio.write(pin,gpio.HIGH)
    end
    tmr.delay(1000)
--    tmr.delay(1000 * 1000 * 2)   -- 100ms timer delay    
end
