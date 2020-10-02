$crystal = 11059200
$baud = 9600
$large

Const Mpu_w = &B11010000
Const Mpu_r = &B11010001

Config Sda = P3.6
Config Scl = P3.7
Config I2cdelay = 0

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = P2.2 , Db5 = P2.3 , Db6 = P2.4
Config Lcdpin = Pin , Db7 = P2.5 , E = P2.1 , Rs = P2.0

Dim Acc_x_high As Byte
Dim Acc_y_high As Byte
Dim Acc_z_high As Byte

Dim Acc_x_low As Byte
Dim Acc_y_low As Byte
Dim Acc_z_low As Byte

Dim Acc_x_int As Integer
Dim Acc_y_int As Integer
Dim Acc_z_int As Integer

Dim X As Integer
X = 0

Lcdinit

Cursor Off
Cls

Do
   Call Mpu6050
   Waitms 200
   If Acc_x_int < 240 And Acc_x_int > 180 And X = 0 Then Call Telp
   If Acc_x_int > 30 And Acc_x_int < 100 Then X = 0
   Waitms 200

   Cls
   Print Acc_x_high ; "    " ; Acc_x_low

   Locate 1 , 1
   Lcd "X = " ; Acc_x_high
   Locate 1 , 9
   Lcd "Y = " ; Acc_y_high
   Locate 2 , 1
   Lcd "Z = " ; Acc_z_high

Loop
Sub Mpu6050
   I2cstart
   I2cwbyte Mpu_w
   I2cwbyte 25                                                'SAMPLE RATE
   I2cwbyte &B00000000
   I2cstop

   I2cstart
   I2cwbyte Mpu_w
   I2cwbyte 26                                                'DIGITAL LPF CONFIG
   I2cwbyte &B00000011
   I2cstop

   I2cstart
   I2cwbyte Mpu_w
   I2cwbyte 27                                                'GYRO CONFIG
   I2cwbyte &B00011000
   I2cstop

   I2cstart
   I2cwbyte Mpu_w
   I2cwbyte 28                                                'ACC CONFI
   I2cwbyte &B00000000
   I2cstop

   I2cstart
   I2cwbyte Mpu_w
   I2cwbyte 107                                               'POWER MANAGEMENT
   I2cwbyte &B00001011
   I2cstop

   Call Acc_read
   Waitms 50

End Sub

Sub Acc_read

   I2cstart
   I2cwbyte Mpu_w
   I2cwbyte 59

   I2cstart
   I2cwbyte Mpu_r
   I2crbyte Acc_x_high , Ack
   I2crbyte Acc_x_low , Ack
   I2crbyte Acc_y_high , Ack
   I2crbyte Acc_y_low , Ack
   I2crbyte Acc_z_high , Ack
   I2crbyte Acc_z_low , Ack
   I2cstop

End Sub

Sub Telp
   X = 1
   Cls
   Lcd "MENELEPON"
   Print "ATD+6285735950340;"
   Wait 8
   Print "ATH"

End Sub