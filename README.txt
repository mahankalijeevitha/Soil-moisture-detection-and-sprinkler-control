Hardware : MicaZ mote, MDA300CA sensor board, EC-10 moisture probe

---------------------------WORKING--------------------------
MDA sensor board provides excitation voltage to the EC-10 moisture sensor probe.
The probe senses the soil moisture and gives out a value on ADC channel A1.
Depening on the sensed data, mote determines if the soil is wet or dry and
accoringly a DC Pump is turned on using excitation valtage of 3.3V from MDA
---------------------------------------------------------------


To Compile:

make micaz install mib510,/dev/ttyUSB0

To Print:

java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:micaz
