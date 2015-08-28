//Rotary Control for Push

//The class gives you three simultaneous float values (between 0 & 1) from each of Push's 11 encoders.
//You get three curves going from 0 to 1 - Linear, y=x^2, y=x^3.

//The functions you need to spork in order to use this class are -
//.rotary0(), .rotary1(), .rotary2(), .rotary3(), .rotary4(), .rotary5(), .rotary6(), .rotary7(), .rotary8(), .rotaryL(), & .rotaryR()
//Spork these right after instantiating the class.
//These functions accept two arguments - resolution (how many turns of the knob scale the enrite range) and default value.

//The variables that hold the values coming out of the rotaries are -
//For Linear curve values - .value0,   .value1,   .value2,   .value3,   .value4,   .value5,   .value6,   .value7,   .value8,   .valueL,   .valueR
//For y=x^2 curve values  - .value0x2, .value1x2, .value2x2, .value3x2, .value4x2, .value5x2, .value6x2, .value7x2, .value8x2, .valueLx2, .valueRx2
//For y=x^3 curve values  - .value0x3, .value1x3, .value2x3, .value3x3, .value4x3, .value5x3, .value6x3, .value7x3, .value8x3, .valueLx3, .valueRx3

//Shaurjya Banerjee - 11/16/2014

public class PushRotaries
{
    PushPort p;
    p.look();
    
    MidiIn pushIn;
    MidiMsg pushMsg;
    MidiOut pushOut;
    MidiMsg lightMsg;
    
    if( !pushIn.open( p.userPort ) ) me.exit();
    <<< "ROTARY CLASS OK! MIDI device:  - ", pushIn.num(), " -> ", pushIn.name() >>>;

    int inData1, inData2, inData3;
    float value0,   value1,   value2,   value3,   value4,   value5,   value6,   value7,   value8,   valueL,   valueR;
    float value0x2, value1x2, value2x2, value3x2, value4x2, value5x2, value6x2, value7x2, value8x2, valueLx2, valueRx2;
    float value0x3, value1x3, value2x3, value3x3, value4x3, value5x3, value6x3, value7x3, value8x3, valueLx3, valueRx3;
   
    //Functions that scale the Push's 11 individual rotary encoders to float values between 0 & 1
    //Resolution defines how many turns are required to go from 0 to 1.
    
    //SCREEN ROTARIES////////////////////////////////////////////////////////////////////////////
    
    //For Screen Rotary0 (Continuous)
    fun float rotary0 (float resolution, float def)
    {
        MidiIn rot0In;
        MidiMsg rot0Msg;
        
        if( !rot0In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        
        def => float value;
        
        while (true)
        {
            rot0In => now;
            while (rot0In.recv(rot0Msg))
            {
                rot0Msg.data1 => rData1;
                rot0Msg.data2 => rData2;
                rot0Msg.data3 => rData3;
                
                //If rotary0 is turned clockwise
                if (rData1==176 && rData2==71 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary0 is turned anti-clockwise
                if (rData1==176 && rData2==71 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}
                
                value => value0;
                //Scale to x^2 and x^3
                Math.pow(value0,2) => value0x2;
                Math.pow(value0,3) => value0x3;
            }
        }  
    }
    
    //For Screen Rotary1 (Continuous)
    fun float rotary1 (float resolution, float def)
    {
        MidiIn rot1In;
        MidiMsg rot1Msg;
        
        if( !rot1In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot1In => now;
            while (rot1In.recv(rot1Msg))
            {
                rot1Msg.data1 => rData1;
                rot1Msg.data2 => rData2;
                rot1Msg.data3 => rData3;
                
                //If rotary1 is turned clockwise
                if (rData1==176 && rData2==72 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary1 is turned anti-clockwise
                if (rData1==176 && rData2==72 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}
                
                value => value1;
                //Scale to x^2 and x^3
                Math.pow(value1,2) => value1x2;
                Math.pow(value1,3) => value1x3;
            }
        }  
    }
    
    //For Screen Rotary2 (Continuous)
    fun float rotary2 (float resolution, float def)
    {
        MidiIn rot2In;
        MidiMsg rot2Msg;
        
        if( !rot2In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot2In => now;
            while (rot2In.recv(rot2Msg))
            {
                rot2Msg.data1 => rData1;
                rot2Msg.data2 => rData2;
                rot2Msg.data3 => rData3;
                
                //If rotary2 is turned clockwise
                if (rData1==176 && rData2==73 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary2 is turned anti-clockwise
                if (rData1==176 && rData2==73 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}

                value => value2;
                //Scale to x^2 and x^3
                Math.pow(value2,2) => value2x2;
                Math.pow(value2,3) => value2x3;
            }
        }  
    }
    
    //For Screen Rotary3 (Continuous)
    fun float rotary3 (float resolution, float def)
    {
        MidiIn rot3In;
        MidiMsg rot3Msg;
        
        if( !rot3In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot3In => now;
            while (rot3In.recv(rot3Msg))
            {
                rot3Msg.data1 => rData1;
                rot3Msg.data2 => rData2;
                rot3Msg.data3 => rData3;
                
                //If rotary3 is turned clockwise
                if (rData1==176 && rData2==74 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary3 is turned anti-clockwise
                if (rData1==176 && rData2==74 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}
                
                value => value3;
                //Scale to x^2 and x^3
                Math.pow(value3,2) => value3x2;
                Math.pow(value3,3) => value3x3;
            }
        }  
    }
    
    //For Screen Rotary4 (Continuous)
    fun float rotary4 (float resolution, float def)
    {
        MidiIn rot4In;
        MidiMsg rot4Msg;
        
        if( !rot4In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot4In => now;
            while (rot4In.recv(rot4Msg))
            {
                rot4Msg.data1 => rData1;
                rot4Msg.data2 => rData2;
                rot4Msg.data3 => rData3;
                
                //If rotary4 is turned clockwise
                if (rData1==176 && rData2==75 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary4 is turned anti-clockwise
                if (rData1==176 && rData2==75 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}
                
                value => value4;
                //Scale to x^2 and x^3
                Math.pow(value4,2) => value4x2;
                Math.pow(value4,3) => value4x3;
            }
        }  
    }
    //For Screen Rotary5 (Continuous)
    fun float rotary5 (float resolution, float def)
    {
        MidiIn rot5In;
        MidiMsg rot5Msg;
        
        if( !rot5In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot5In => now;
            while (rot5In.recv(rot5Msg))
            {
                rot5Msg.data1 => rData1;
                rot5Msg.data2 => rData2;
                rot5Msg.data3 => rData3;
                
                //If rotary5 is turned clockwise
                if (rData1==176 && rData2==76 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary5 is turned anti-clockwise
                if (rData1==176 && rData2==76 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}

                value => value5;
                //Scale to x^2 and x^3
                Math.pow(value5,2) => value5x2;
                Math.pow(value5,3) => value5x3;
            }
        }  
    }
    //For Screen Rotary6 (Continuous)
    fun float rotary6 (float resolution, float def)
    {
        MidiIn rot6In;
        MidiMsg rot6Msg;
        
        if( !rot6In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot6In => now;
            while (rot6In.recv(rot6Msg))
            {
                rot6Msg.data1 => rData1;
                rot6Msg.data2 => rData2;
                rot6Msg.data3 => rData3;
                
                //If rotary6 is turned clockwise
                if (rData1==176 && rData2==77 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary6 is turned anti-clockwise
                if (rData1==176 && rData2==77 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}
                
                value => value6;
                //Scale to x^2 and x^3
                Math.pow(value6,2) => value6x2;
                Math.pow(value6,3) => value6x3;
            }
        }  
    }
    //For Screen Rotary7 (Continuous)
    fun float rotary7 (float resolution, float def)
    {
        MidiIn rot7In;
        MidiMsg rot7Msg;
        
        if( !rot7In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot7In => now;
            while (rot7In.recv(rot7Msg))
            {
                rot7Msg.data1 => rData1;
                rot7Msg.data2 => rData2;
                rot7Msg.data3 => rData3;
                
                //If rotary7 is turned clockwise
                if (rData1==176 && rData2==78 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary7 is turned anti-clockwise
                if (rData1==176 && rData2==78 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}
                
                value => value7;
                //Scale to x^2 and x^3
                Math.pow(value7,2) => value7x2;
                Math.pow(value7,3) => value7x3;
            }
        }  
    }
    //For Screen Rotary8 (Continuous)
    fun float rotary8 (float resolution, float def)
    {
        MidiIn rot8In;
        MidiMsg rot8Msg;
        
        if( !rot8In.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rot8In => now;
            while (rot8In.recv(rot8Msg))
            {
                rot8Msg.data1 => rData1;
                rot8Msg.data2 => rData2;
                rot8Msg.data3 => rData3;
                
                //If rotary8 is turned clockwise
                if (rData1==176 && rData2==79 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotary8 is turned anti-clockwise
                if (rData1==176 && rData2==79 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}

                value => value8;
                //Scale to x^2 and x^3
                Math.pow(value8,2) => value8x2;
                Math.pow(value8,3) => value8x3;
            }
        }  
    }
    
    //OTHER ROTARIES///////////////////////////////////////////////////////////////////////////
    
    //For Rotary L (Stepped)
    fun float rotaryL (float resolution, float def) 
    {
        MidiIn rotLIn;
        MidiMsg rotLMsg;
        
        if( !rotLIn.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rotLIn => now;
            while (rotLIn.recv(rotLMsg))
            {
                rotLMsg.data1 => rData1;
                rotLMsg.data2 => rData2;
                rotLMsg.data3 => rData3;
                
                //If rotaryL is turned clockwise
                if (rData1==176 && rData2==14 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotaryL is turned anti-clockwise
                if (rData1==176 && rData2==14 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}

                value => valueL;
                //Scale to x^2 and x^3
                Math.pow(valueL,2) => valueLx2;
                Math.pow(valueL,3) => valueLx3;
            }
        }  
        
    }
    //For Rotary R (Continuous)
    fun float rotaryR (float resolution, float def) 
    {
        MidiIn rotRIn;
        MidiMsg rotRMsg;
        
        if( !rotRIn.open( p.userPort ) ) me.exit();
        
        int rData1, rData2, rData3;
        
        (1.0/(127.0*resolution)) => float increment;
        def => float value;
        
        while (true)
        {
            rotRIn => now;
            while (rotRIn.recv(rotRMsg))
            {
                rotRMsg.data1 => rData1;
                rotRMsg.data2 => rData2;
                rotRMsg.data3 => rData3;
                
                //If rotaryR is turned clockwise
                if (rData1==176 && rData2==15 && rData3 > 0 && rData3 < 20)
                {
                    value + (rData3*increment) => value;
                }
                //If the rotaryR is turned anti-clockwise
                if (rData1==176 && rData2==15 && rData3 > 120 && rData3 < 128)
                {
                    value + ((rData3-128)*increment) => value;
                }
                //Limit range between 0 & 1
                if (value <= 0) {0 => value;}
                if (value >= 1) {1 => value;}
                
                value => valueR;
                //Scale to x^2 and x^3
                Math.pow(valueR,2) => valueRx2;
                Math.pow(valueR,3) => valueRx3;
            }
        }  
    }
}