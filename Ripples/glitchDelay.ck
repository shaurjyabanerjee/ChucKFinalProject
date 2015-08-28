<<<"glitchDelay.ck by Mike Leisz, 12/01/14">>>;

//custom feedback delay chubgraph

public class GlitchDelay extends Chubgraph{
    
    Pan2 master => outlet;
    
    ADSR env;
    
    inlet => Pan2 dry => Pan2 wet;
    wet => Delay d => wet;
    
    wet => master;
    dry => master;
    
    Math.randomf() => float updateInc;
    
    //set initial delay params
    0.999 => d.gain;
    10::second => d.max;
    .5::second => d.delay;
    
    (Math.random2f(.01,.1)::second,Math.random2f(.01,.1)::second,
    1.0,Math.random2f(.01,.1)::second) => env.set;
    
    //boolean switch;
    true => int running;
    
    fun void update(){
        while (running){
            (Std.fabs(Math.sin(now/updateInc::second)) + .01)::second => d.delay;
            Std.fabs(Math.cos(now/updateInc::second) + .05) => wet.gain;
            Std.fabs(Math.sin(now/updateInc::second) - .05) => dry.gain;
            
            Math.sin((now/updateInc::second)*pi) => wet.pan;
            Math.cos((now/updateInc::second)*pi) => dry.pan;
            
            Math.sin((now/updateInc::second)*pi) => master.pan;
            
            1 => env.keyOn;
            
            (updateInc)::second => now;
            
            (Math.random2f(.01,.1)::second,Math.random2f(.01,.1)::second,
            Math.random2f(.01,.1),Math.random2f(.01,.1)::second) => env.set;
        }
    }
}