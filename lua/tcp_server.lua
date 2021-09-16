pin=4
gpio.mode(pin,gpio.OUTPUT)
gpio.write(pin,gpio.LOW)
srv=net.createServer(net.TCP,28800)  --创建tcp服务器
srv:listen(8888,function(conn)    --8888为端口号，可以改，但必须与客户端的端口号保持一致
    conn:on("receive",function(conn,payload) --接受客户端传来的数据，并存入payload
    
    if (payload >= "31") then   --如果接受到的数据大于“31”，注意这里的比较大小是字符串的比较
        gpio.write(pin,gpio.LOW)  --点亮LED
        print(1)
    elseif (payload <="31") then  --如果接受到的数据小于“31”，注意这里的比较大小是字符串的比较
        gpio.write(pin,gpio.HIGH)  --熄灭LED
        print(0)
    else
        print(3)  --这里的print（3）和前面的print都是为了从左边观察，没什么用
    end
        
    print(payload)  --打印输出接受到的数据
    end)
end)

