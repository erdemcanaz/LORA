EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Module:Arduino_Nano_v3.x A?
U 1 1 619A49CE
P 3650 4200
F 0 "A?" H 3650 3111 50  0000 C CNN
F 1 "Arduino_Nano_v3.x" H 3650 3020 50  0000 C CNN
F 2 "Module:Arduino_Nano" H 3650 4200 50  0001 C CIN
F 3 "http://www.mouser.com/pdfdocs/Gravitech_Arduino_Nano3_0.pdf" H 3650 4200 50  0001 C CNN
	1    3650 4200
	1    0    0    -1  
$EndComp
$Comp
L Erdem:lora U?
U 1 1 619A5A15
P 6550 4150
F 0 "U?" H 5822 3829 50  0000 R CNN
F 1 "lora" H 5822 3920 50  0000 R CNN
F 2 "" H 6150 4400 50  0001 C CNN
F 3 "" H 6150 4400 50  0001 C CNN
	1    6550 4150
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 619A62F0
P 5500 3550
F 0 "R?" H 5430 3504 50  0000 R CNN
F 1 "10k" H 5430 3595 50  0000 R CNN
F 2 "" V 5430 3550 50  0001 C CNN
F 3 "~" H 5500 3550 50  0001 C CNN
	1    5500 3550
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 619A71DB
P 5500 3950
F 0 "R?" H 5570 3996 50  0000 L CNN
F 1 "22k" H 5570 3905 50  0000 L CNN
F 2 "" V 5430 3950 50  0001 C CNN
F 3 "~" H 5500 3950 50  0001 C CNN
	1    5500 3950
	1    0    0    -1  
$EndComp
Text GLabel 5500 4250 3    50   Input ~ 0
GND
Wire Wire Line
	5500 4100 5500 4250
Text GLabel 5500 3300 1    50   Input ~ 0
SOFTWARE_TX
Wire Wire Line
	5500 3300 5500 3400
Text GLabel 6350 3850 0    50   Input ~ 0
SOFTWARE_RX
Text GLabel 6350 3950 0    50   Input ~ 0
AUX_PIN
Text GLabel 6050 4050 0    50   Input ~ 0
5V
Wire Wire Line
	6050 4050 6250 4050
Text GLabel 6050 4400 0    50   Input ~ 0
GND
Wire Wire Line
	6650 4150 6650 4400
$Comp
L Device:CP C?
U 1 1 619A8946
P 6250 4200
F 0 "C?" H 6368 4246 50  0000 L CNN
F 1 "470uF" H 6368 4155 50  0000 L CNN
F 2 "" H 6288 4050 50  0001 C CNN
F 3 "~" H 6250 4200 50  0001 C CNN
	1    6250 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 4350 6250 4400
Wire Wire Line
	6250 4400 6050 4400
Wire Wire Line
	5500 3700 5500 3750
Wire Wire Line
	6250 4050 6650 4050
Connection ~ 6250 4050
Wire Wire Line
	6350 3950 6650 3950
Wire Wire Line
	6350 3850 6650 3850
Wire Wire Line
	5500 3750 6650 3750
Connection ~ 5500 3750
Wire Wire Line
	5500 3750 5500 3800
Wire Wire Line
	6250 4400 6650 4400
Connection ~ 6250 4400
Text GLabel 6300 3550 0    50   Input ~ 0
GND
Wire Wire Line
	6300 3550 6600 3550
Wire Wire Line
	6600 3550 6600 3650
Wire Wire Line
	6600 3650 6650 3650
Connection ~ 6600 3550
Wire Wire Line
	6600 3550 6650 3550
$EndSCHEMATC
