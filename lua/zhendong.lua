
pin=2 --D2

gpio.mode(pin,gpio.INPUT)
--gpio.write(pin, gpio.LOW)


tmr.create():alarm(2000, tmr.ALARM_AUTO, function()
    result = gpio.read(pin) --a number, 0 = low, 1 = high

    print("result", result);

end)    


--