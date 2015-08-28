//Supersaw Class 
//Shaurjya Banerjee - 11/13/2014


public class SuperSaw extends Chubgraph 
{
    Pan2 master => outlet;
    Pan2 buss => ADSR env => master;
   
    //The supersaw sound network
    SawOsc s1 => buss.left;
    SawOsc s2 => Pan2 p1 => buss;
    SawOsc s3 => buss;
    SawOsc s4 => Pan2 p2 => buss;
    SawOsc s5 => buss.right;
    SawOsc s6 => buss.left;
    SawOsc s7 => buss.right;
    
    0 => float minDetune; 
    float maxDetune;
    
    float atk, dec, sus, rel;
  
    float detune1, detune2, detune3, detune4, detune5, detune6, detune7;
    
    buss.gain(0.7);
    master.gain(0.7);
    0 => s1.gain => s2.gain => s3.gain => s4.gain => s5.gain => s6.gain => s7.gain;
    
    //Overloaded function which sets the frequencies for the saw oscillators
    fun void freq(int note)
    {
        spork ~ mod();
        (Std.mtof( note - 12 ) - detune1) => s1.freq;
        (Std.mtof( note + 24 ) - detune2) => s2.freq;
        (Std.mtof( note - 0  ) - detune3) => s3.freq;
        (Std.mtof( note + 12 ) + detune4) => s4.freq;
        (Std.mtof( note - 12 ) + detune5) => s5.freq;
        (Std.mtof( note - 24 ) - detune6) => s6.freq;
        (Std.mtof( note - 24 ) + detune7) => s7.freq;
    }
    
    fun void freq(float freq)
    {
        (freq/2) - detune1 => s1.freq;
        (freq*4) - detune2 => s2.freq;
        freq - detune3 => s3.freq;
        (freq*2) + detune4 => s4.freq;
        (freq/2) + detune5 => s5.freq;
        (freq/4) - detune6 => s6.freq;
        (freq/4) + detune7 => s7.freq;
    }
    
    fun void noteOn(float vel)
    {
        (vel/7.0) => s1.gain => s2.gain => s3.gain => s4.gain => s5.gain => s6.gain => s7.gain;
        (atk::second, dec::second, sus, rel::second) => env.set;
        1 => env.keyOn;
    }
    
    fun void noteOff(float vel)
    {
        1 => env.keyOff;
    }
    
    fun void mod ()
    {
        while (true)
        {
            //Supply the detune variables with random float values between 1.0 & 3.0
            Math.random2f(minDetune,maxDetune) => detune1;
            Math.random2f(minDetune,maxDetune) => detune2;
            Math.random2f(minDetune,maxDetune) => detune3;
            Math.random2f(minDetune,maxDetune) => detune4;
            Math.random2f(minDetune,maxDetune) => detune5;
            Math.random2f(minDetune,maxDetune) => detune6;
            Math.random2f(minDetune,maxDetune) => detune7;
   
            Math.random2f(-0.8, 0.0) => p1.pan;
            Math.random2f( 0.0, 0.8) => p2.pan;
            
            0.01::second => now;
            me.exit();
        }
    }
}