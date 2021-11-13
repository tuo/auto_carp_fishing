## ARDUINO


* make sure the `upload speed` is max like 921600 to speed up upload

* settings -> `arduio` , change `Path` to `/Applications` for mac


https://blog.anoff.io/2020-12-programming-arduino-esp-with-vs-code/



https://forum.arduino.cc/t/converting-raw-data-from-mpu-6050-to-yaw-pitch-and-roll/465354/7

https://forum.arduino.cc/t/yaw-calculation-from-mpu6050/317028

https://forum.arduino.cc/t/converting-rotation-angles-from-mpu6050-to-roll-pitch-yaw/392641/3


#define MPU6050_GYRO_YG_ST 0x40
#define MPU6050_GYRO_ZG_ST 0x20
#define MPU6050_GYRO_FS_250 0x00 // +-250°/s  131
#define MPU6050_GYRO_FS_500 0x08 // +-500°/s  65.6
#define MPU6050_GYRO_FS_1000 0x10 // +-1000°/s  32.8
#define MPU6050_GYRO_FS_2000 0x18 // +-2000°/s 16.4
// Register 28 - Accelerometer Configuration
#define MPU6050_GYRO_XA_ST 0x80 // Self-test response = Sensor output with self-test enabled - Sensor output without self-test enabled
#define MPU6050_GYRO_YA_ST 0x40
#define MPU6050_GYRO_ZA_ST 0x20
#define MPU6050_ACCEL_AFS_2 0x00 // +-2g  16384 LSB/g
#define MPU6050_ACCEL_AFS_4 0x08 // +-4g  8192 
#define MPU6050_ACCEL_AFS_8 0x10 // +-8g 4096
#define MPU6050_ACCEL_AFS_16 0x18 // +-16g 2048
————————————————
