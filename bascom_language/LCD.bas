Dim A As Byte

$baud = 9600
$crystal = 11059200

A = 0
Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = P1.2 , Db5 = P1.3 , Db6 = P1.4 , Db7 = P1.5 , E = P1.1 , Rs = P1.0
Lcd 0

Do
A = A + 1
Cls
Print A
Lcd A
Waitms 1000

Loop Until A = 255