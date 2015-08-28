//Filter Delay Chubgrpah -
//Filters incoming audio into 4 "bands" and runs each "band" to its own delay loop

//Shaurjya Banerjee - 11/16/2014

public class FilterDelay extends Chubgraph
{
    //SOUND CHAIN///////////////////////////////////////////////////

    //Pan2 "channel" for each "band" from Chubgraph inlet
    inlet => Pan2 B1In => Pan2 B2In => Pan2 B3In => Pan2 B4In;

    //Master channel goes to Chubgraph outlet
    Pan2 master => outlet;
    
    //Bands => filters
    B1In => LPF B1filt;
    B2In => BPF B2filt;
    B3In => BPF B3filt;
    B4In => HPF B4filt;
    
    //Create a parallel "Dry" chain which goes to the master
    B1In => Pan2 Dry;
    B2In => Dry;
    B3In => Dry;
    B4In => Dry;
    
    Dry => master;
    
    //Filters => delays => volume busses
    B1filt => Delay B1dly => Pan2 B1vol;
    B2filt => Delay B2dly => Pan2 B2vol;
    B3filt => Delay B3dly => Pan2 B3vol;
    B4filt => Delay B4dly => Pan2 B4vol; 
    
    //Delay feedback loops
    B1dly =>  B1dly;
    B2dly =>  B2dly;
    B3dly =>  B3dly;
    B4dly =>  B4dly; 
    
    //Volume busses connected back to the master
    B1vol => master;
    B2vol => master;
    B3vol => master;
    B4vol => master;
    
    //Set maximum delay time to allocate memory to the delay lines
    3::second => B1dly.max;
    3::second => B2dly.max;
    3::second => B3dly.max;
    3::second => B4dly.max;

    //PARAMETER HANDLERS /////////////////////////////////////////////
    
    //Set the volume of the "Dry" buss
    Dry.gain(0.1);
    
    //Variables to control the parameters of this effect class
    float B1freq, B2freq, B3freq, B4freq;
    float B1fdbk, B2fdbk, B3fdbk, B4fdbk;
    
    //Function to set the filter cutoff points for each of the four bands
    fun void filt (float freq1, float freq2, float freq3, float freq4)
    {
        B1filt.freq(freq1);
        B2filt.freq(freq2);
        B3filt.freq(freq3);
        B4filt.freq(freq4);
    }
    
    //Function to set the delay feedback ammounts per band
    fun void fdbk (float fdbk1, float fdbk2, float fdbk3, float fdbk4)
    {
        fdbk1 => B1dly.gain;
        fdbk2 => B2dly.gain;
        fdbk3 => B3dly.gain;
        fdbk4 => B4dly.gain;
    }
    
    //Function to set delay times for each individulal delay line
    fun void dtime (float time1, float time2, float time3, float time4)
    {
        time1::second => B1dly.delay;
        time2::second => B2dly.delay;
        time3::second => B3dly.delay;
        time4::second => B4dly.delay;
    }
    
    //Function that outputs a sin wave for modulation of the delay parameters
    fun float sinScale (float min, float max, float mod)
    {
        float ans;
        max-min => float range;
        min+(mod*range) => ans;
        Std.fabs(ans) => ans;
        return ans;
    }
}