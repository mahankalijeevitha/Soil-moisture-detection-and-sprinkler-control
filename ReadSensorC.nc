#include "Timer.h"
#include "printf.h"
float Voltage = 0, vwc=0;


module ReadSensorC
{
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1;
	uses interface Leds;
	uses interface Boot;

	uses interface GeneralIO as TWO_HALF_VOLT;
	uses interface GeneralIO as THREE_VOLT;
	uses interface Read<uint16_t> as MoistureSensor;
}
implementation
{
	void printfFloat(float toBePrinted) //function to print out float values
	{
	     uint32_t fi, f0, f1, f2;
	     char c;
	     float f = toBePrinted; // toBePrinted is the float value passed to this function to be printed
	
	     if (f<0){ // accounting for negative numbers
	       c = '-'; f = -f;
	     } else {
	       c = ' ';
	     }
	
	     // integer portion.
	     fi = (uint32_t) f;
	
	     // decimal portion:get index for up to 3 decimal places, which can be variable depending on the application.
	     f = f - ((float) fi);
	     f0 = f*10;   f0 %= 10;// shifting out each digit after the decimal point and storing it in an integer variable
	     f1 = f*100;  f1 %= 10;
	     f2 = f*1000; f2 %= 10;
	     printf("%c%ld.%d%d%d", c, fi, (uint8_t) f0, (uint8_t) f1, (uint8_t) f2);//using the standard printf the float values are printed
	}

	event void Boot.booted()
	{
		call TWO_HALF_VOLT.set(); //at power-up the 2.5V excitation is set
		call Timer0.startPeriodic(5000);//Timer set for sensing moisture value
		call Timer1.startPeriodic(3000);//Timer set for turning off the DC pump
	}
	event void MoistureSensor.readDone(error_t result, uint16_t val) //control comes here after sensor has sensed and taken a reading
	{
		
		if (result != SUCCESS) // If there is an error then we toggle LED2
			call Leds.led2Toggle();
		else
			call Leds.led0Toggle(); // if the read is a success then toggle LED0
		Voltage = (((float)val)*2.5)/4096; // calculate voltage as per formula in the manual
		vwc = 100*(0.000936 * (Voltage * 1000) - 0.376) + 0.5; //calculate volumetric water content as per formula in manual
		printf("Raw Read: %u \nVoltage",val);
		printfFloat(Voltage);
		printf("Volumetric Water Content conversion:");
		printfFloat(vwc);
		printf("\n");
		call Leds.led1Toggle();// Toggle LED1 after printing
		if (((float)val)<=0.5) // check if soil is dry
		{
		call THREE_VOLT.set();// if yes give actuation signal of 3.3V as input to driver circuit
		call Timer1.startPeriodic(3000);// leave pump on for 3 second
		}
	}
	event void Timer0.fired()
	{
		
		call MoistureSensor.read();// each time timer 0 fires, take a reading
		
	}
	event void Timer1.fired()
	{
		
		call THREE_VOLT.clr();//turn off pump after 3 second
	}
}

