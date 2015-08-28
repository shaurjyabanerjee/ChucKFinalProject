<<<"grainSample.ck by Mike Leisz, 12/01/14">>>;

//class for manipulating sndbufs

public class Grain{
    SndBuf smpl;
    GlitchDelay glitch;
    
    0 => int numSamples;
    
    //element array for randomization
    [0, 1] @=> int base[];
    
    //boolean on/off
    true => int running;
    
    //load sample
    fun void loadSample(string path){
        path => smpl.read;
        smpl.samples() => smpl.pos;
        
        1 => smpl.loop;
    }
    
    //chuck sample to dac
    //versus chucking through glitchdelay class
    fun void chuckSample(UGen output){
        smpl => glitch => output;
        spork ~ glitch.update();
    }
    
    fun void kill(UGen output){
        false => running;
        false => glitch.running;
        smpl !=> glitch !=> output;
    }
    
    //plays sample at manipulated position
    //and in randomized pattern
    fun void play(int length, dur division){
        //randomize pattern
        aGen(base, length) @=> int pattern[];
        
        //calculate beats
        division * 0.5 => dur subDiv_1;
        subDiv_1 * 0.5 => dur subDiv_2;
        subDiv_2 * 0.5 => dur subDiv_3;
        subDiv_3 * 0.5 => dur subDiv_4;
        
        [subDiv_1, subDiv_2, subDiv_3, subDiv_4] @=> dur beats[];
        
        //play sample
        while (running){
            0 => numSamples;
            for (int i; i < pattern.cap(); i++){
                Math.random2(0, i) + i => smpl.rate;
                ((Math.sin(now/second*pi) * 500) + 1000) $ int => int posMod;
                numSamples + 100 => numSamples;
                
                if (pattern[i] == 1){
                    0.50 => smpl.gain;
                } else {
                    0.00 => smpl.gain;
                }
                
                beats[Math.random2(0, beats.cap() - 1)] => dur beat;
                
                now + division => time later;
                while (now < later){
                    numSamples => smpl.pos;
                    beat => now;
                }
            }
        }
    }
    
    //randomize sample pattern
    fun int[] aGen(int elements[], int limit){
        int rArray[limit];
        
        for (0 => int i; i < limit; i++){
            elements[Math.random2(0, elements.cap() - 1)] => rArray[i];
        }
        
        return rArray;
    }
}