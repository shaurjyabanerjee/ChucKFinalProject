<<<"ripple.ck by Mike Leisz, 12/01/14">>>;

//simple "ripple" object
//increases radius @ update duration

public class Ripple{

    .15::second => dur sixteenth;
    sixteenth/4 => dur tick;
    
    [16, 8, 4, 2] @=> int durs[];
    int myDur;
    
    int counter;
    int age;
    
    float centerX, centerY;
    int r;
    
    false => int collision;
    false => int hasCollided;
    
    fun void update(){
        if (collision){
            true => hasCollided;
        }
        r++;
    }
}