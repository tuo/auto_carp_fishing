

id  = 0 -- always 0
scl = 7 -- set pin 6 as scl
sda = 6 -- set pin 7 as sda
MPU6050SlaveAddress = 0x68

--AccelScaleFactor = 16384;   -- sensitivity scale factor respective to full scale setting provided in datasheet 
-- GyroScaleFactor = 131;

-- https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf
-- https://www.youtube.com/watch?v=j-kE0AMEWy4&ab_channel=JoopBrokking
AccelScaleFactor = 4096;  --8g/s
GyroScaleFactor = 65.5; -- ± 500 °/s


MPU6050_REGISTER_SMPLRT_DIV   =  0x19
MPU6050_REGISTER_USER_CTRL    =  0x6A
MPU6050_REGISTER_PWR_MGMT_1   =  0x6B
MPU6050_REGISTER_PWR_MGMT_2   =  0x6C
MPU6050_REGISTER_CONFIG       =  0x1A
MPU6050_REGISTER_GYRO_CONFIG  =  0x1B
MPU6050_REGISTER_ACCEL_CONFIG =  0x1C
MPU6050_REGISTER_FIFO_EN      =  0x23
MPU6050_REGISTER_INT_ENABLE   =  0x38
MPU6050_REGISTER_ACCEL_XOUT_H =  0x3B
MPU6050_REGISTER_SIGNAL_PATH_RESET  = 0x68


gyro_x_cal = 0.0
gyro_y_cal = 0.0
gyro_z_cal = 0.0

gyro_z =0.0
gyro_y=0.0
gyro_x=0.0

angle_roll=0.0
angle_pitch=0.0 

angle_roll_start=nil
angle_pitch_start=nil

function I2C_Write(deviceAddress, regAddress, data)
    i2c.start(id)       -- send start condition
    if (i2c.address(id, deviceAddress, i2c.TRANSMITTER))-- set slave address and transmit direction
    then
        i2c.write(id, regAddress)  -- write address to slave
        i2c.write(id, data)  -- write data to slave
        i2c.stop(id)    -- send stop condition
    else
        print("I2C_Write fails")
    end
end

function I2C_Read(deviceAddress, regAddress, SizeOfDataToRead)
    response = 0;
    i2c.start(id)       -- send start condition
    if (i2c.address(id, deviceAddress, i2c.TRANSMITTER))-- set slave address and transmit direction
    then
        i2c.write(id, regAddress)  -- write address to slave
        i2c.stop(id)    -- send stop condition
        i2c.start(id)   -- send start condition
        i2c.address(id, deviceAddress, i2c.RECEIVER)-- set slave address and receive direction
        response = i2c.read(id, SizeOfDataToRead)   -- read defined length response from slave
        i2c.stop(id)    -- send stop condition
        return response
    else
        print("I2C_Read fails")
    end
    return response
end

function unsignTosigned16bit(num)   -- convert unsigned 16-bit no. to signed 16-bit no.
    if num > 32768 then 
        num = num - 65536
    end
    return num
end

function MPU6050_Init() --configure MPU6050
    tmr.delay(150000) -- delay for 150 ms
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_SMPLRT_DIV, 0x07)
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_PWR_MGMT_1, 0x01)
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_PWR_MGMT_2, 0x00)
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_CONFIG, 0x00)
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_GYRO_CONFIG, 0x08)-- set +/-500 degree/second full scale
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_ACCEL_CONFIG, 0x10)-- set +/- 8g full scale  
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_FIFO_EN, 0x00)
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_INT_ENABLE, 0x01)
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_SIGNAL_PATH_RESET, 0x00)
    I2C_Write(MPU6050SlaveAddress, MPU6050_REGISTER_USER_CTRL, 0x00)
end



function read_data() 


    tmr.delay(1000) 

    local data = I2C_Read(MPU6050SlaveAddress, MPU6050_REGISTER_ACCEL_XOUT_H, 14)
    --print("data", data)
    
    local AccelX = unsignTosigned16bit((bit.bor(bit.lshift(string.byte(data, 1), 8), string.byte(data, 2))))
    local AccelY = unsignTosigned16bit((bit.bor(bit.lshift(string.byte(data, 3), 8), string.byte(data, 4))))
    local AccelZ = unsignTosigned16bit((bit.bor(bit.lshift(string.byte(data, 5), 8), string.byte(data, 6))))
    local Temperature = unsignTosigned16bit(bit.bor(bit.lshift(string.byte(data,7), 8), string.byte(data,8)))
    local GyroX = unsignTosigned16bit((bit.bor(bit.lshift(string.byte(data, 9), 8), string.byte(data, 10))))
    local GyroY = unsignTosigned16bit((bit.bor(bit.lshift(string.byte(data, 11), 8), string.byte(data, 12))))
    local GyroZ = unsignTosigned16bit((bit.bor(bit.lshift(string.byte(data, 13), 8), string.byte(data, 14))))
    gyro_x = GyroX
    gyro_y = GyroY 
    gyro_z = GyroZ
    return AccelX, AccelY, AccelZ, Temperature
    


end

i2c.setup(id, sda, scl, i2c.SLOW)   -- initialize i2c
MPU6050_Init()

tmr.delay(10000) 

stableCount = 100
for i=1,stableCount do 
    print(i) 
    read_data()    
end

loop_timer = tmr.now()

count = 0
while true do


    local AccelX, AccelY, AccelZ, Temperature = read_data()

    print(AccelX/AccelScaleFactor, AccelY/AccelScaleFactor, AccelZ/AccelScaleFactor, Temperature )  
    
--  count = count + 1
--
--  if count == 20 then
--    angle_roll_start = angle_roll
--    
--  end
--
----  if count > 50 then
----    angle_roll_start = angle_roll
----    tmr.delay(1000 * 1000 * 1000)
----  end
--  
--  local x,y,z = read_data()
--
--  gyro_x = gyro_x - gyro_x_cal;      
--  gyro_y = gyro_y - gyro_y_cal;      
--  gyro_z = gyro_z - gyro_z_cal; 
--
--   -- Gyro angle calculations
--   -- 0.0000611 = 1 / (250Hz / 65.5)
--
--  
--  angle_pitch = angle_pitch + gyro_x * factor;                       
--  angle_roll = angle_roll + gyro_y * factor;                       

--  if angle_roll_start == nil then
--    print("angle_roll_start:", angle_roll_start)
--    angle_roll_start = angle_roll
--  end  
--
--  if angle_pitch_start == nil then
--    print("angle_pitch_start:", angle_pitch_start)
--    angle_pitch_start = angle_pitch
--  end  
-- roll -x, 
-- pitch - y
-- yaw - z

  -- 250hz - 4000 microseconds(us)
  -- 1hz - 1000000 microseconds(us)
--  print(angle_roll, angle_roll_start)  

--  if angle_roll_start ~= nil then
--    print("gap: ",(math.abs(angle_roll) - math.abs(angle_roll_start)))
--  end
  
  --tmr.delay(4000)  
--  while  tmr.now() - loop_timer < sleep_time do end;
--  loop_timer = tmr.now()
end     
