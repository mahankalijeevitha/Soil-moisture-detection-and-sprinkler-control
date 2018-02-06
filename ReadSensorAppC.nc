#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration ReadSensorAppC
{
}

implementation
{
	components MainC, ReadSensorC as App, LedsC;
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer0;
	#ifdef NEW_PRINTF_SEMANTICS
	components PrintfC;
	components SerialStartC;
	#endif
	components MicaBusC;
	components new SensorMDA300CA() as Mda300;
	App -> MainC.Boot;

	App.Timer0 -> Timer0;
	App.Timer1 -> Timer1;
	App.Leds -> LedsC;
	App.TWO_HALF_VOLT -> MicaBusC.PW2;
	App.THREE_VOLT -> MicaBusC.PW3;
	App.MoistureSensor -> Mda300.ADC_1; //wire for input of volage through the sensor i.e channel A1
}

