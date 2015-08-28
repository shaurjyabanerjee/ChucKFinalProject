<<<"genOsc.ck by Mike Leisz, 12/01/14, 12/01/14">>>;

//"generative" pulseOsc class

public class GenOsc{
    PulseOsc s; 
    OscDelay fx; //sound chain
    JCRev r;
    UGen output;
    
    0.1 => r.mix;
    
    0.0 => s.gain;
    Math.randomf() => s.width;
    
    //default melody/scale degree values
    60 => int fnd;
    //[0, 3, 7, 8, 12] @=> int scale_deg[];
    [0, 1, 3, 5, 6, 8, 10, 12] @=> int scale_deg[];
    aGen(scale_deg, Math.random2(4, 16)) @=> int mel[];
    
    fun void chuckOsc(UGen out){
        out @=> output;
        s => r => fx => out;
    }
    
    fun void init(float t, int iX, int iY, int r){
        spork ~ fx.glitchFX(t, r);
        spork ~ play(0.1, iX, iY, t::second, 
        Math.random2(2, mel.cap() - 1), 0, mel);
    }
    
    //play function calls itself when numLoops argument ends
    //takes randomized melody array
    //and plays rhythmically via %
    fun void play(float volume, int numBeats, int numLoops, dur beat, int modAmount, int degree, int seq[]){
        int count;
        while (count < numLoops){
            for (int i; i < numBeats; i++){
                Std.mtof(fnd + degree + seq[i % seq.cap()]) => s.freq;
                
                if (i % modAmount == 0){
                    volume => s.gain;
                } else {
                    0.00 => s.gain;
                }
                
                beat => now;
            }
            count++;
        }
        false => fx.running;
        s !=> r !=> fx !=> output;
    }
    
    //randomize melody
    fun int[] aGen(int elements[], int limit){
        int rArray[limit];
        
        for (0 => int i; i < limit; i++){
            elements[Math.random2(0, elements.cap() - 1)] => rArray[i];
        }
        
        return rArray;
    }
}