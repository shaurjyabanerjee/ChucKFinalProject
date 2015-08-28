<<<"oscDelay.ck by Mike Leisz, 12/01/14">>>;

//feedback delay chubgraph optimized for "genOsc" objects

public class OscDelay extends Chubgraph{
    Pan2 master => outlet;
    
    //randomize vars to offset delay params
    Math.random2f(.1, 1.0)::second => dur dMod;
    Math.random2f(.1, 1.0)::second => dur mixMod;
    
    int qVar;
    
    //sound chain
    
    inlet => ADSR env => HPF filt => Pan2 dry => Pan2 wet;
    wet => Delay d => wet;
    
    //fx wet and dry
    wet => master;
    dry => master;
    
    //randomize env
    (Math.random2f(.01,.1)::second,Math.random2f(.01,.1)::second,
    Math.random2f(.01,.1),Math.random2f(.01,.1)::second) => env.set;
    
    //set initial delay params
    0.999 => d.gain;
    10::second => d.max;
    .5::second => d.delay;
    
    //boolean switch
    true => int running;
    
    //function takes any ugen as input
    //and a beat for update time
    fun void glitchFX(float updateInc, int q){
        q => qVar;
        
        //update fx
        while (running){
            (Std.fabs(Math.sin(now/dMod)) + .01)::second => d.delay;
            Std.fabs(Math.cos(now/mixMod)) + 0.1 => wet.gain;
            Std.fabs(Math.sin(now/mixMod)) - 0.1 => dry.gain;
            (Math.sin(now/.25::second) * 250.0) + 500.0 => filt.freq;
            (Std.fabs(Math.sin(now/1::second)) + 1) * qVar => filt.Q;
            
            Math.sin(now/dMod) => wet.pan;
            
            1 => env.keyOn;
            
            updateInc::second => now;
            
            1 => env.keyOff;
            
            (Math.random2f(.01,.1)::second,Math.random2f(.01,.1)::second,
            Math.random2f(.01,.1),Math.random2f(.01,.1)::second) => env.set;
        }
    }
}