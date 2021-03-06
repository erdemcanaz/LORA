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
L MCU_Module:Arduino_Nano_v3.x A1
U 1 1 619A49CE
P 3650 4200
F 0 "A1" H 3650 3111 50  0000 C CNN
F 1 "Arduino_Nano_v3.x" H 3650 3020 50  0000 C CNN
F 2 "Module:Arduino_Nano" H 3650 4200 50  0001 C CIN
F 3 "http://www.mouser.com/pdfdocs/Gravitech_Arduino_Nano3_0.pdf" H 3650 4200 50  0001 C CNN
	1    3650 4200
	1    0    0    -1  
$EndComp
$Comp
L Erdem:lora U2
U 1 1 619A5A15
P 6550 4150
F 0 "U2" H 5822 3829 50  0000 R CNN
F 1 "lora" H 5822 3920 50  0000 R CNN
F 2 "erdem_lib:lora" H 6150 4400 50  0001 C CNN
F 3 "" H 6150 4400 50  0001 C CNN
	1    6550 4150
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 619A62F0
P 5500 3550
F 0 "R1" H 5430 3504 50  0000 R CNN
F 1 "10k" H 5430 3595 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5430 3550 50  0001 C CNN
F 3 "~" H 5500 3550 50  0001 C CNN
	1    5500 3550
	-1   0    0    1   
$EndComp
$Comp
L Device:R R2
U 1 1 619A71DB
P 5500 3950
F 0 "R2" H 5570 3996 50  0000 L CNN
F 1 "22k" H 5570 3905 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5430 3950 50  0001 C CNN
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
L Device:CP C1
U 1 1 619A8946
P 6250 4200
F 0 "C1" H 6368 4246 50  0000 L CNN
F 1 "470uF" H 6368 4155 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D8.0mm_P5.00mm" H 6288 4050 50  0001 C CNN
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
Text GLabel 3050 4400 0    50   Input ~ 0
SOFTWARE_RX
Wire Wire Line
	3050 4400 3150 4400
Text GLabel 3050 4500 0    50   Input ~ 0
SOFTWARE_TX
Wire Wire Line
	3050 4500 3150 4500
Text GLabel 3050 4000 0    50   Input ~ 0
AUX_PIN
Wire Wire Line
	3050 4000 3150 4000
Wire Wire Line
	2500 4300 3150 4300
Text GLabel 3750 5450 3    50   Input ~ 0
GND
Wire Wire Line
	3750 5200 3750 5450
Wire Wire Line
	3650 5200 3750 5200
Connection ~ 3750 5200
Text GLabel 3850 3200 1    50   Input ~ 0
5V
$Comp
L Erdem:pinout U1
U 1 1 619B07E9
P 4900 5500
F 0 "U1" V 4679 4872 50  0000 R CNN
F 1 "pinout" V 4588 4872 50  0000 R CNN
F 2 "erdem_lib:pinout" H 4900 5500 50  0001 C CNN
F 3 "" H 4900 5500 50  0001 C CNN
	1    4900 5500
	0    -1   -1   0   
$EndComp
Text GLabel 5100 5500 1    50   Input ~ 0
5V
Wire Wire Line
	5100 5500 5100 5600
Text GLabel 3000 3600 0    50   Input ~ 0
RX
Wire Wire Line
	3000 3600 3150 3600
Text GLabel 3000 3700 0    50   Input ~ 0
TX
Wire Wire Line
	3000 3700 3150 3700
Text GLabel 5400 5500 1    50   Input ~ 0
GND
Wire Wire Line
	5400 5500 5400 5600
Text GLabel 5200 5500 1    50   Input ~ 0
TX
Text GLabel 5300 5500 1    50   Input ~ 0
RX
Wire Wire Line
	5300 5500 5300 5600
Wire Wire Line
	5200 5500 5200 5600
Wire Wire Line
	4350 3700 4350 2800
Wire Wire Line
	4350 2800 2500 2800
Wire Wire Line
	2500 2800 2500 4300
Wire Wire Line
	4150 3700 4350 3700
$EndSCHEMATC
