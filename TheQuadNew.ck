//The Quad - A Musique Concrète performance environment for Ableton Push

//Shaurjya Banerjee - 12/01/2014

public class TheQuad
{
    //Text for the screen UI
    //|<-------------------------ENTER YOUR TEXT HERE------------------------->|
    [[ "Z","O","N","E","1","-","-","-",  "-",  "-","-","R","h","o","d","e","y" ],
     [ "L","i","S","a","1","R","a","t",  "e",  " ","Z","o","n","e","V","o","l" ],
     [ "O","c","t","U","p"," "," "," ",  " ",  " ","R","e","c","L","o","o","p" ],
     [ "O","c","t","D","o","w","n"," ",  " ",  " "," "," "," "," "," "," "," " ]] @=> string screenB1[][];
    //|<----------------------ENTER YOUR TEXT HERE---------------------------->|
    [[ "Z","O","N","E","2","-","-","-",  "-",  "-","-","-","-","M","o","o","g" ],
     [ "L","i","S","a","2","R","a","t",  "e",  " ","Z","o","n","e","V","o","l" ],
     [ "O","c","t","U","p"," "," "," ",  " ",  " ","R","e","c","L","o","o","p" ],
     [ "O","c","t","D","o","w","n"," ",  " ",  " "," "," "," "," "," "," "," " ]] @=> string screenB2[][];
    //|<----------------------ENTER YOUR TEXT HERE---------------------------->|
    [[ "Z","O","N","E","3","-","-","-",  "-",  "-","-","-","B","e","a","t","s" ],
     [ "L","i","S","a","3","R","a","t",  "e",  " ","Z","o","n","e","V","o","l" ],
     [ " "," "," "," "," "," "," "," ",  " ",  " ","R","e","c","L","o","o","p" ],
     [ " "," "," "," "," "," "," "," ",  " ",  " "," "," "," "," "," "," "," " ]] @=> string screenB3[][];
    //|<----------------------ENTER YOUR TEXT HERE---------------------------->|
    [[ "Z","O","N","E","4","-","-","-",  "-",  "S","u","p","e","r","S","a","w" ],
     [ "L","i","S","a","4","R","a","t",  "e",  " ","Z","o","n","e","V","o","l" ],
     [ "O","c","t","U","p"," "," "," ",  " ",  " ","R","e","c","L","o","o","p" ],
     [ "O","c","t","D","o","w","n"," ",  " ",  " "," "," "," "," "," "," "," " ]] @=> string screenB4[][];
    
    //Instantiate the classes needed for this class to run
    PushPort q;
    q.look();
    PushScreen p;
    p.printScreen (screenB1, screenB2, screenB3, screenB4);
    PushRotaries r;
 
    //Spork shreds to listen to the data from each rotary
    spork ~ r.rotary0(2, 0.3); //Zone1 - LiSa Rate
    spork ~ r.rotary1(1, 0.5); //Zone1 - Volume
    spork ~ r.rotary2(2, 0.3); //Zone2 - LiSa Rate
    spork ~ r.rotary3(1, 0.5); //Zone2 - Volume
    spork ~ r.rotary4(2, 0.3); //Zone3 - LiSa Rate
    spork ~ r.rotary5(1, 0.5); //Zone3 - Volume
    spork ~ r.rotary6(2, 0.3); //Zone4 - LiSa Rate
    spork ~ r.rotary7(1, 0.5); //Zone4 - Volume
    spork ~ r.rotaryR(1, 0.8); //LiSa Buss - Volume
    spork ~ r.rotary8(1, 0.5); //Master Volume
     
    //Sound chain
    Pan2 master => dac;
    Pan2 beatsBuss;

    //SndBuf for each sample
    SndBuf clap    => beatsBuss;  //ID - 100
    SndBuf click1  => beatsBuss;  //ID - 101
    SndBuf click2  => beatsBuss;  //ID - 102
    SndBuf click3  => beatsBuss;  //ID - 103
    SndBuf click4  => beatsBuss;  //ID - 104
    SndBuf click5  => beatsBuss;  //ID - 105
    SndBuf cowbell => beatsBuss;  //ID - 106
    SndBuf hat1    => beatsBuss;  //ID - 107
    SndBuf hat2    => beatsBuss;  //ID - 108
    SndBuf hat3    => beatsBuss;  //ID - 109
    SndBuf hat4    => beatsBuss;  //ID - 110
    SndBuf kik1    => beatsBuss;  //ID - 111
    SndBuf kik2    => beatsBuss;  //ID - 112
    SndBuf kik3    => beatsBuss;  //ID - 113
    SndBuf kik4    => beatsBuss;  //ID - 114
    SndBuf kik5    => beatsBuss;  //ID - 115
    SndBuf snr1    => beatsBuss;  //ID - 116
    SndBuf snr2    => beatsBuss;  //ID - 117
    SndBuf snr3    => beatsBuss;  //ID - 118
    SndBuf fx1     => beatsBuss;  //ID - 119
    SndBuf fx2     => beatsBuss;  //ID - 120
    SndBuf fx3     => beatsBuss;  //ID - 121
    SndBuf fx4     => beatsBuss;  //ID - 122
    SndBuf fx5     => beatsBuss;  //ID - 123
    
    //Sound source--|--FilterDelay--|-InstVolume-|---PathToLiSa's--|--master| 
    Rhodey   q1    => FilterDelay d1 => Pan2 ch1 => Pan2 lisafeed1 => master;
    Moog     q2    => FilterDelay d2 => Pan2 ch2 => Pan2 lisafeed2 => master;
    beatsBuss      => FilterDelay d3 => Pan2 ch3 => Pan2 lisafeed3 => master;
    SuperSaw q4    => FilterDelay d4 => Pan2 ch4 => Pan2 lisafeed4 => master;

    //Running the entire LiSa Buss through a Pan2 object being used as a killswitch
    Pan2 lisaBuss => Pan2 lisaMute => master;

    //Each LiSa feed goes to the corresponding effects and killswitch busses
    lisafeed1 => LiSa l1 => Pan2 lisa1vol => Pan2 lisa1kill => lisaBuss;
    lisafeed2 => LiSa l2 => Pan2 lisa2vol => Pan2 lisa2kill => lisaBuss;
    lisafeed3 => LiSa l3 => Pan2 lisa3vol => Pan2 lisa3kill => lisaBuss;
    lisafeed4 => LiSa l4 => Pan2 lisa4vol => Pan2 lisa4kill => lisaBuss;

    //Patched into FX busses
    lisa1vol => Pan2 lisa1FX1; 
    lisa1vol => Pan2 lisa1FX2;

    lisa2vol => Pan2 lisa2FX1; 
    lisa2vol => Pan2 lisa2FX2;
    
    lisa3vol => Pan2 lisa3FX1; 
    lisa3vol => Pan2 lisa3FX2;
    
    lisa4vol => Pan2 lisa4FX1; 
    lisa4vol => Pan2 lisa4FX2;

    //FX Set1
    Pan2 effects1 => NRev reverb => master;
    reverb.mix(0.6);

    //Keep effects busses muted till they are triggered
    lisa1FX1.gain(0);
    lisa2FX1.gain(0);
    lisa3FX1.gain(0);
    lisa4FX1.gain(0);

    //Patch feed from each LiSa channel into effects buss
    lisa1FX1 => effects1;
    lisa2FX1 => effects1;
    lisa3FX1 => effects1;
    lisa4FX1 => effects1;

    //FX Set2
    Pan2 effects2 => Echo modulate => Chorus chor => master;
    chor.mix(0.9);

    //Keep effects busses muted till they are triggered
    lisa1FX2.gain(0);
    lisa2FX2.gain(0);
    lisa3FX2.gain(0);
    lisa4FX2.gain(0);

    //Patch feed from each LiSa channel into effects buss
    lisa1FX2 => effects2;
    lisa2FX2 => effects2;
    lisa3FX2 => effects2;
    lisa4FX2 => effects2;

    //Set modulation parameters
    chor.modFreq(0.8);
    chor.modDepth(0.8);
    modulate.delay(1::second);
    modulate.max(0.8::second);
    modulate.mix(1);

    //Assign unique ID numbers for each sample
    100 => int clapID;
    101 => int click1ID;
    102 => int click2ID;
    103 => int click3ID;
    104 => int click4ID;
    105 => int click5ID;
    106 => int cowbellID;
    107 => int hat1ID;
    108 => int hat2ID;
    109 => int hat3ID;
    110 => int hat4ID;
    111 => int kik1ID;
    112 => int kik2ID;
    113 => int kik3ID;
    114 => int kik4ID;
    115 => int kik5ID;
    116 => int snr1ID;
    117 => int snr2ID;
    118 => int snr3ID;
    119 => int fx1ID;
    120 => int fx2ID;
    121 => int fx3ID;
    122 => int fx4ID;
    123 => int fx5ID;

    //Allocating memory to LiSa's
    10::second => l1.duration;
    10::second => l2.duration;
    10::second => l3.duration;
    10::second => l4.duration;

    //Setting the loop start points for each of the LiSa's
    l1.loopStart(0::samp);
    l2.loopStart(0::samp);
    l3.loopStart(0::samp);
    l4.loopStart(0::samp);
    
    //Setting the loop mode for each of the LiSa's
    l1.loop(1);
    l2.loop(1);
    l3.loop(1);
    l4.loop(1);

    //Some time variables to control loop length of LiSa's
    time past1   , past2   , past3   , past4;
    time present1, present2, present3, present4;
    
    //Setting the envelope of the SuperSaw chubgraph
    5.0 => q4.maxDetune;
    0.07 => q4.atk;
    0.04 => q4.dec;
    0.75 => q4.sus;
    0.03 => q4.rel;
    
    MidiIn pushIn;
    MidiMsg pushMsg;
    MidiOut pushOut;
    MidiMsg lightMsg;

    //Open the Midi port of Push's User Mode using the Push port class
    if( !pushIn.open( q.userPort ) ) me.exit();
    <<< "QUAD IN OK! MIDI device: - ", pushIn.num(), " -> ", pushIn.name() >>>;
    
    if( !pushOut.open( q.userPort ) ) me.exit();
    <<< "QUAD OUT OK! MIDI device: - ", pushOut.num(), " -> ", pushOut.name() >>>;
    
    //Dummy array to define the positions of the four 'zones' on Push's pads
    [[1,1,1,1,   2,2,2,2],
     [1,1,1,1,   2,2,2,2],
     [1,1,1,1,   2,2,2,2],
     [1,1,1,1,   2,2,2,2],
    
     [4,4,4,4,   3,3,3,3],
     [4,4,4,4,   3,3,3,3],
     [4,4,4,4,   3,3,3,3],
     [4,4,4,4,   3,3,3,3]] @=> int dummyZones[][];

     //Dummy array to hold the ID numbers of the beats section
     //Assign SndBuf's to the Zone 3 pads here
     [[0,0,0,0,    0,0,0,0],
      [0,0,0,0,    0,0,0,0],
      [0,0,0,0,    0,0,0,0],
      [0,0,0,0,    0,0,0,0],

      [0,0,0,0,    fx1ID   ,fx2ID   ,fx3ID   ,fx4ID    ],
      [0,0,0,0,    click1ID,click2ID,click3ID,click4ID ],
      [0,0,0,0,    clapID  ,snr1ID  ,snr2ID  ,cowbellID],
      [0,0,0,0,    kik1ID  ,kik2ID  ,hat2ID  ,hat3ID   ]] @=> int dummyBeats[][];

    //Scales in intervals 
    [0,2,4,5,7,9,11] @=> int majorScale[]; 
    [0,3,5,6,7,10]   @=> int bluesScale[];
    [0,2,4,6,7,9,11] @=> int lydianMode[];
    [0,2,4,5,7,9,11] @=> int ionianMode[];
    [0,2,4,5,7,9,10] @=> int mixolydianMode[];
    [0,2,3,5,7,9,10] @=> int dorianMode[];
    [0,2,3,5,7,8,10] @=> int aeolianMode[];
    [0,1,3,5,7,8,10] @=> int phrygianMode[];
    [0,1,3,5,6,8,10] @=> int locrianMode[];
    [0,1,2,3,4,5,6,7,8,9,10,11] @=> int chromatic[];
    
    //Dummy array to hold the generated melody sequences
    [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
     [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
     [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
     [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] @=> int melodySeries[][];
    
    //This is the function you need to call to play the QUAD
    fun void playQuad()
    {
        //VARIABLES////////////////////////////////////////// 
        
        [0,0] @=> int pos[];
        [0,0] @=> int pos2[];
        
        int inData1, inData2, inData3;
        
        //Base color of each quadrant
        21 => int quad1color;
        49 => int quad2color;
        85 => int quad3color;
        45 => int quad4color;
        
        //Note On color of each quadrant 
        72 => int light1color;
        72 => int light2color;
        72 => int light3color;
        72 => int light4color;
        
        //Root note
        60 => int tonic;
        
        //Octave variables for each zone
        (tonic-12) => int oct1;
        (tonic+48) => int oct2;
        (tonic) => int oct3;
        (tonic-12) => int oct4;
        
        //Counter variables for each quad
        int mcount0, mcount1, mcount2, mcount3;
        int noteq1, noteq2, noteq3, noteq4;
        int killq1, killq2, killq3, killq4;

        float beatVel;

        //Booleans for button states
        true => int masterButtonState;

        true => int kill1State;
        true => int kill2State;
        true => int kill3State;
        true => int kill4State;

        false => int looper1state;
        false => int looper2state;
        false => int looper3state;
        false => int looper4state;

        //Call the functions nessecary to play the Quad
        loadSamples();
        melodyMaker(locrianMode) @=> melodySeries;
        drawQuad(dummyZones, quad1color, quad2color, quad3color, quad4color);
        
        //Spork the two functions needed to parse data from the rotaries
        spork ~ volumeControl();
        spork ~ rateControl();
                
        while (true)
        {
            pushIn => now;
            
            while ( pushIn.recv(pushMsg) )
            {
                //Store the message as three integer variables
                pushMsg.data1 => inData1;
                pushMsg.data2 => inData2;
                pushMsg.data3 => inData3;
                
                //If note on (which isnt from one of the rotaries & isnt an accidental trigger)
                if (inData1==144 && inData2>10 && inData3>10)
                {   
                    //Store the struck note as its x,y position on Push pads
                    MtoXY(inData2) @=> pos;
                    
                    //Block of four if statements with instructions for each quadrant
                    
                    //QUADRANT 1 - Rhodey
                    if (XYtoQuad(pos)==1)
                    {
                        //Acess the melody array and play the note
                        oct1 + melodySeries[0][mcount0] => noteq1;
                        Std.mtof(noteq1) => q1.freq;
                        1 => q1.noteOn;
                        
                        //Assign random values to the filter delay parameters with each note on
                        d1.filt(Math.random2f(100, 300), Math.random2f(300, 3000), Math.random2f(3000,10000), Math.random2f(6000,11000)); 
                        d1.fdbk(Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99));
                        d1.dtime(Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8));
                        
                        //Light the pad to its corresponding color
                        144 => lightMsg.data1;
                        inData2 => lightMsg.data2;
                        light1color => lightMsg.data3;
                        pushOut.send(lightMsg);
                        
                        //Reset the melody array
                        mcount0++;
                        if (mcount0==19) {0 => mcount0;}
                    }

                    //QUADRANT 2 - Moog
                    if (XYtoQuad(pos)==2)
                    {
                        //Acess the melody array and play a note
                        oct2 + melodySeries[1][mcount1] => noteq2;
                        Std.mtof(noteq2) => q2.freq;
                        1 => q2.noteOn;
                        
                        //Assign random values to the filter delay parameters with each note on
                        d2.filt(Math.random2f(100, 300), Math.random2f(300, 3000), Math.random2f(3000,10000), Math.random2f(6000,11000)); 
                        d2.fdbk(Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99));
                        d2.dtime(Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8));

                        
                        //Light the pad to its corresponding color
                        144 => lightMsg.data1;
                        inData2 => lightMsg.data2;
                        light2color => lightMsg.data3;
                        pushOut.send(lightMsg);
                        
                        //Reset the melody array
                        mcount1++;
                        if (mcount1==19) {0 => mcount1;}
                    }

                    //QUADRANT 3 - Beats
                    if (XYtoQuad(pos)==3)
                    {
                        //Scale the input velocity to a float between 0 & 1
                        (inData3/127.00) => beatVel;

                        //Choose a sample to play by comparig it to the sample's ID number
                        if      (dummyBeats[pos[1]][pos[0]] == clapID)    {spork ~ sampHandler(clap, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == click1ID)  {spork ~ sampHandler(click1, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == click2ID)  {spork ~ sampHandler(click2, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == click3ID)  {spork ~ sampHandler(click3, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == click4ID)  {spork ~ sampHandler(click4, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == click5ID)  {spork ~ sampHandler(click5, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == cowbellID) {spork ~ sampHandler(cowbell, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == hat1ID)    {spork ~ sampHandler(hat1, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == hat2ID)    {spork ~ sampHandler(hat2, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == hat3ID)    {spork ~ sampHandler(hat3, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == hat4ID)    {spork ~ sampHandler(hat4, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == kik1ID)    {spork ~ sampHandler(kik1, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == kik2ID)    {spork ~ sampHandler(kik2, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == kik3ID)    {spork ~ sampHandler(kik3, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == kik4ID)    {spork ~ sampHandler(kik4, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == kik5ID)    {spork ~ sampHandler(kik5, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == snr1ID)    {spork ~ sampHandler(snr1, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == snr2ID)    {spork ~ sampHandler(snr2, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == snr3ID)    {spork ~ sampHandler(snr3, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == fx1ID)     {spork ~ sampHandler(fx1, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == fx2ID)     {spork ~ sampHandler(fx2, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == fx3ID)     {spork ~ sampHandler(fx3, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == fx4ID)     {spork ~ sampHandler(fx4, 1.5, beatVel);}
                        else if (dummyBeats[pos[1]][pos[0]] == fx5ID)     {spork ~ sampHandler(fx5, 1.5, beatVel);}
                    
                        //Assign random values to the filter delay parameters with each note on
                        d3.filt(Math.random2f(100, 300), Math.random2f(300, 3000), Math.random2f(3000,10000), Math.random2f(6000,11000)); 
                        d3.fdbk(Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99));
                        d3.dtime(Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8));
  
                        //Light the pad to its corresponding color
                        144 => lightMsg.data1;
                        inData2 => lightMsg.data2;
                        light3color => lightMsg.data3;
                        pushOut.send(lightMsg);
                    }

                    //QUADRANT 4 - SuperSaw
                    if (XYtoQuad(pos)==4)
                    {
                        //Acess the melody array and play the note
                        oct4 + melodySeries[3][mcount3] => noteq4;
                        q4.freq(noteq4);
                        q4.noteOn(1);
                        
                        //Assign random values to the filter delay parameters with each note on
                        d4.filt(Math.random2f(100, 300), Math.random2f(300, 3000), Math.random2f(3000,10000), Math.random2f(6000,11000)); 
                        d4.fdbk(Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99), Math.random2f(0.30, 0.99));
                        d4.dtime(Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8), Math.random2f(0.01, 0.8));

                        //Light the pad to its corresponding color
                        144 => lightMsg.data1;
                        inData2 => lightMsg.data2;
                        light4color => lightMsg.data3;
                        pushOut.send(lightMsg);

                        //Reset the melody array
                        mcount3++;
                        if (mcount3==19) {0 => mcount3;}
                    }

                }//NoteOnBrace
                
                //If Note Off (which isnt from one of the rotaries)
                if (inData1==128 && inData2>10)
                {    
                    //Store the struck note as its x,y position on Push pads                                            
                    MtoXY(inData2) @=> pos2;
                    
                    //Block of four if statements with instructions for each quadrant

                    //QUADRANT 1 - Rhodey
                    if (XYtoQuad(pos2)==1) {1 => q1.noteOff;}

                    //QUADRANT 2 - Moog
                    if (XYtoQuad(pos2)==2) {1 => q2.noteOff;}
                     
                    //QUADRANT 4 - SuperSaw
                    if (XYtoQuad(pos2)==4) {q4.noteOff(1);}
                    
                    //Turn off the pad
                    128 => lightMsg.data1;
                    inData2 => lightMsg.data2;
                    inData3 => lightMsg.data3;
                    pushOut.send(lightMsg);
                    
                    //Re-Draw the entire qud layout on pads and buttons
                    drawQuad(dummyZones, quad1color, quad2color, quad3color, quad4color);

                } //NoteOffBrace
                
                //OCTAVE UP/DOWN//////////////////////////////////////////////////////
                
                //Q1 OCTAVE
                if (inData1==176 && inData2==20 && inData3==127)
                {
                    oct1+12=> oct1;
                    //Limit range
                    if (oct1>=120){oct1-12 => oct1;}   
                }
                if (inData1==176 && inData2==102 && inData3==127) 
                { 
                    oct1-12 => oct1;
                    //Limit range
                    if (oct1<=0){oct1+12 => oct1;}
                }
                
                //Q2 OCTAVE
                if (inData1==176 && inData2==22 && inData3==127) 
                { 
                    oct2+12 => oct2;
                    if (oct2>=120){oct2-12 => oct2;}
                }
                if (inData1==176 && inData2==104 && inData3==127) 
                { 
                    oct2-12 => oct2;
                    //Limit range
                    if (oct2<=0){oct2+12 => oct2;}
                }
                
                //Q3 OCTAVE
                if (inData1==176 && inData2==24 && inData3==127) 
                { 
                    oct3+12 => oct3;
                    //Limit range
                    if (oct3>=120){oct3-12 => oct3;}
                }
                if (inData1==176 && inData2==106 && inData3==127) 
                { 
                    oct3-12 => oct3;
                    //Limit range
                    if (oct3<=0){oct3+12 => oct3;}
                }
                
                //Q4 OCTAVE
                if (inData1==176 && inData2==26 && inData3==127) 
                { 
                    oct4+12 => oct4;
                    //Limit range
                    if (oct4>=120){oct4-12 => oct4;}
                }
                if (inData1==176 && inData2==108 && inData3==127) 
                {
                    oct4-12 => oct4;
                    //Limit range
                    if (oct4<=0){oct4+12 => oct4;}
                }
                
                //LOOP RECORD SECTION//////////////////////////////////////////

                //LOOP RECORDER 1
                //Loop On
                if (inData1==176 && inData2==21 && inData3==127)
                {
                    now => past1;
                    //Start recording into LiSa
                    1 => l1.record;

                    //LightStuff
                    176 => lightMsg.data1;
                    21 => lightMsg.data2;
                    03 => lightMsg.data3;
                    pushOut.send(lightMsg);  
                }
                //Loop Off
                if (inData1==176 && inData2==21 && inData3==0)
                {
                    0 => l1.record;
                    1 => l1.play;

                    //LightStuff
                    176 => lightMsg.data1;
                    21 => lightMsg.data2;
                    01 => lightMsg.data3;
                    pushOut.send(lightMsg);
                    
                    now => present1;
                    present1 - past1 => dur loopLength1;
                    l1.loopEnd(loopLength1);
                }

                //LOOP RECORDER 2
                //Loop On
                if (inData1==176 && inData2==23 && inData3==127)
                {
                    now => past2;
                    //Start recording into LiSa
                    1 => l2.record;

                    //LightStuff
                    176 => lightMsg.data1;
                    23 => lightMsg.data2;
                    03 => lightMsg.data3;
                    pushOut.send(lightMsg);
                }
                //Loop Off
                if (inData1==176 && inData2==23 && inData3==0)
                {
                    0 => l2.record;
                    1 => l2.play;
                    1 => l2.loop;

                    //LightStuff
                    176 => lightMsg.data1;
                    23 => lightMsg.data2;
                    01 => lightMsg.data3;
                    pushOut.send(lightMsg);

                    now => present2;
                    present2 - past2 => dur loopLength2;
                    l2.loopEnd(loopLength2);
                }

                //LOOP RECORDER 3
                //Loop On
                if (inData1==176 && inData2==25 && inData3==127)
                {
                    now => past3;
                    //Start recording into LiSa
                    1 => l3.record;

                    //LightStuff
                    176 => lightMsg.data1;
                    25 => lightMsg.data2;
                    03 => lightMsg.data3;
                    pushOut.send(lightMsg);  
                }
                //Loop Off
                if (inData1==176 && inData2==25 && inData3==0)
                {
                    0 => l3.record;
                    1 => l3.play;
                    1 => l3.loop;

                    //LightStuff
                    176 => lightMsg.data1;
                    25 => lightMsg.data2;
                    01 => lightMsg.data3;
                    pushOut.send(lightMsg);

                    now => present3;
                    present3 - past3 => dur loopLength3;
                    l3.loopEnd(loopLength3);
                }

                //LOOP RECORDER 4
                //Loop On
                if (inData1==176 && inData2==27 && inData3==127)
                {
                    now => past4;
                    //Start recording into LiSa
                    1 => l4.record;

                    //LightStuff
                    176 => lightMsg.data1;
                    27 => lightMsg.data2;
                    03 => lightMsg.data3;
                    pushOut.send(lightMsg);   
                }
                //Loop Off
                if (inData1==176 && inData2==27 && inData3==0)
                {
                    0 => l4.record;
                    1 => l4.play;
                    1 => l4.loop;

                    //LightStuff
                    176 => lightMsg.data1;
                    27 => lightMsg.data2;
                    01 => lightMsg.data3;
                    pushOut.send(lightMsg);

                    now => present4;
                    present4 - past4 => dur loopLength4;
                    l4.loopEnd(loopLength4);
                }


                //ADDITIONAL LiSa controls

                //If "MASTER" button on Push is pressed, silence (BUT DONT CLEAR) ALL the LiSa's
                if (inData1==176 && inData2==28 && inData3==127)
                {
                    if (masterButtonState == false)
                    {
                        lisaMute.gain(1);

                        //Turn off the button
                        176 => lightMsg.data1;
                        28 => lightMsg.data2;
                        0 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa's HAVE BEEN UN-MUTED">>>;

                        true => masterButtonState;
                    }

                    else if (masterButtonState==true)
                    {
                        //Mute 
                        lisaMute.gain(0);

                        //Turn on the button
                        176 => lightMsg.data1;
                        28 => lightMsg.data2;
                        127 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa's HAVE BEEN MUTED">>>;

                        false => masterButtonState;
                    }
                }

                //If "VOLUME" button (114) is pressed, silence LiSa 1
                if (inData1==176 && inData2==114 && inData3==127)
                {
                    if (kill1State == false)
                    {
                        lisa1kill.gain(1);

                        //Turn off the button
                        176 => lightMsg.data1;
                        114 => lightMsg.data2;
                        0 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 1 HAS BEEN UN-MUTED">>>;

                        true => kill1State;
                    }

                    else if (kill1State==true)
                    {
                        //Mute 
                        lisa1kill.gain(0);

                        //Turn on the button
                        176 => lightMsg.data1;
                        114 => lightMsg.data2;
                        127 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 1 HAS BEEN MUTED">>>;

                        false => kill1State;
                    }
                }

                //If "PAN & SEND" button (115) is pressed, silence LiSa 2
                if (inData1==176 && inData2==115 && inData3==127)
                {
                    if (kill2State == false)
                    {
                        lisa2kill.gain(1);

                        //Turn off the button
                        176 => lightMsg.data1;
                        115 => lightMsg.data2;
                        0 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 2 HAS BEEN UN-MUTED">>>;

                        true => kill2State;
                    }

                    else if (kill2State==true)
                    {
                        //Mute 
                        lisa2kill.gain(0);

                        //Turn on the button
                        176 => lightMsg.data1;
                        115 => lightMsg.data2;
                        127 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 2 HAS BEEN MUTED">>>;

                        false => kill2State;
                    }
                }


                //If "CLIP" button (113) is pressed, silence LiSa 3
                if (inData1==176 && inData2==113 && inData3==127)
                {
                    if (kill3State == false)
                    {
                        lisa3kill.gain(1);

                        //Turn off the button
                        176 => lightMsg.data1;
                        113 => lightMsg.data2;
                        0 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 3 HAS BEEN UN-MUTED">>>;

                        true => kill3State;
                    }

                    else if (kill3State==true)
                    {
                        //Mute 
                        lisa3kill.gain(0);

                        //Turn on the button
                        176 => lightMsg.data1;
                        113 => lightMsg.data2;
                        127 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 3 HAS BEEN MUTED">>>;

                        false => kill3State;
                    }
                }

                //If "TRACK" button (112) is pressed, silence LiSa 4
                if (inData1==176 && inData2==112 && inData3==127)
                {
                    if (kill4State == false)
                    {
                        lisa4kill.gain(1);

                        //Turn off the button
                        176 => lightMsg.data1;
                        112 => lightMsg.data2;
                        0 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 4 HAS BEEN UN-MUTED">>>;

                        true => kill4State;
                    }

                    else if (kill4State==true)
                    {
                        //Mute 
                        lisa4kill.gain(0);

                        //Turn on the button
                        176 => lightMsg.data1;
                        112 => lightMsg.data2;
                        127 => lightMsg.data3;
                        pushOut.send(lightMsg);

                        <<<"LiSa 4 HAS BEEN MUTED">>>;

                        false => kill4State;
                    }
                }

                //If "SESSION REC" button is pressed, clear all the LiSa's
                if (inData1==176 && inData2==86 && inData3==127)
                {
                    l1.clear();
                    l2.clear();
                    l3.clear();
                    l4.clear();

                    <<< "ALL LiSa's HAVE BEEN CLEARED" >>>;
                }

                //If "UNDO" button (119) is pressed, clear LiSa 1
                if (inData1==176 && inData2==119 && inData3==127)
                {
                    l1.clear();
                    <<<"ZONE 1 LiSa HAS BEEN CLEARED">>>;
                }

                //If "DELETE" button (118) is pressed, clear LiSa 2
                if (inData1==176 && inData2==118 && inData3==127)
                {
                    l2.clear();
                    <<<"ZONE 2 LiSa HAS BEEN CLEARED">>>;
                }

                //If "DOUBLE" button (117) is pressed, clear LiSa 3
                if (inData1==176 && inData2==117 && inData3==127)
                {
                    l3.clear();
                    <<<"ZONE 3 LiSa HAS BEEN CLEARED">>>;
                }

                //If "QUANTIZE" button (116) is pressed, clear LiSa 4
                if (inData1==176 && inData2==116 && inData3==127)
                {
                    l4.clear();
                    <<<"ZONE 4 LiSa HAS BEEN CLEARED">>>;
                }

                // FX TRIGGER SECTION /////////////////////////////////////////////

                //If "1/32t" button (43) is pressed, send LiSa1 to FX1
                if (inData1==176 && inData2==43 && inData3==127) {lisa1FX1.gain(1);}
                if (inData1==176 && inData2==43 && inData3==0)   {lisa1FX1.gain(0);}

                //If "1/32" button (42) is pressed, send LiSa2 to FX1
                if (inData1==176 && inData2==42 && inData3==127) {lisa2FX1.gain(1);}
                if (inData1==176 && inData2==42 && inData3==0)   {lisa2FX1.gain(0);}

                //If "1/16t" button (41) is pressed, send LiSa3 to FX1
                if (inData1==176 && inData2==41 && inData3==127) {lisa3FX1.gain(1);}
                if (inData1==176 && inData2==41 && inData3==0)   {lisa3FX1.gain(0);}

                //If "1/16" button (40) is pressed, send LiSa4 to FX1
                if (inData1==176 && inData2==40 && inData3==127) {lisa4FX1.gain(1);}
                if (inData1==176 && inData2==40 && inData3==0)   {lisa4FX1.gain(0);}

                //If "1/8t" button (39) is pressed, send LiSa1 to FX2
                if (inData1==176 && inData2==39 && inData3==127) {lisa1FX2.gain(1);}
                if (inData1==176 && inData2==39 && inData3==0)   {lisa1FX2.gain(0);}

                //If "1/8" button (38) is pressed, send LiSa2 to FX2
                if (inData1==176 && inData2==38 && inData3==127) {lisa2FX2.gain(1);}
                if (inData1==176 && inData2==38 && inData3==0)   {lisa2FX2.gain(0);}

                //If "1/4t" button (37) is pressed, send LiSa3 to FX2
                if (inData1==176 && inData2==37 && inData3==127) {lisa3FX2.gain(1);}
                if (inData1==176 && inData2==37 && inData3==0)   {lisa3FX2.gain(0);}

                //If "1/4" button (36) is pressed, send LiSa4 to FX2
                if (inData1==176 && inData2==36 && inData3==127) {lisa4FX2.gain(1);}
                if (inData1==176 && inData2==36 && inData3==0)   {lisa4FX2.gain(0);}

                // OTHER CONTROLS /////////////////////////////////////////////////

                //If "TAP TEMPO" button(3) is pressed, clear all the stuck pads
                if (inData1==176 && inData2==3 && inData3==127) {clearQuad();}
            }
        }
    }      
    
    //INTERFACING FUNCTIONS //////////////////////////////////////////////////////////////
    
    //Function that draws the quad grid on Push Pads
    fun void drawQuad (int zones [][], int qcolor1, int qcolor2, int qcolor3, int qcolor4)
    {
        [20, 22, 26] @=> int octUp[];
        [102, 104, 108] @=> int octDown[];
        [86, 116, 117, 118, 119, 3, 43, 42, 41, 40] @=> int ccs[];
        [39, 38, 37, 36] @=> int cc2[];
        
        127 => int octUcolor;
        127 => int octDcolor;
        
        for (7 => int i; i>=0; i--)
        {
            for (int j; j<=7; j++)
            {
                //light quadrant 1
                if (zones[i][j] == 1)
                {
                    144 => lightMsg.data1;
                    XYtoM (j,i) => lightMsg.data2;
                    qcolor1 => lightMsg.data3;
                    pushOut.send(lightMsg);
                }
                //light quadrant 2
                if (zones[i][j] == 2)
                {
                    144 => lightMsg.data1;
                    XYtoM (j,i) => lightMsg.data2;
                    qcolor2 => lightMsg.data3;
                    pushOut.send(lightMsg);
                }
                //light quadrant 3
                if (zones[i][j] == 3)
                {
                    144 => lightMsg.data1;
                    XYtoM (j,i) => lightMsg.data2;
                    qcolor3 => lightMsg.data3;
                    pushOut.send(lightMsg);
                }
                //light quadrant 4
                if (zones[i][j] == 4)
                {
                    144 => lightMsg.data1;
                    XYtoM (j,i) => lightMsg.data2;
                    qcolor4 => lightMsg.data3;
                    pushOut.send(lightMsg);   
                }                   
            }
        }
        
        //For OctaveUP buttons
        for (int i; i<octUp.cap(); i++)
        {
            176 => lightMsg.data1;
            octUp[i] => lightMsg.data2;
            octUcolor => lightMsg.data3;
            pushOut.send(lightMsg);
        }
        //For OctaveDOWN buttons
        for (int j; j<octDown.cap(); j++)
        {
            176 => lightMsg.data1;
            octDown[j] => lightMsg.data2;
            octDcolor => lightMsg.data3;
            pushOut.send(lightMsg);
        }

        //For loop for misc. buttons that recieve CC's
        for (int i; i<ccs.cap(); i++)
        {
            176 => lightMsg.data1;
            ccs[i] => lightMsg.data2;
            127 => lightMsg.data3;
            pushOut.send(lightMsg);
        }

        //Second set of effects trigger buttons
        for (int j; j<cc2.cap(); j++)
        {
            176 => lightMsg.data1;
            cc2[j] => lightMsg.data2;
            1 => lightMsg.data3;
            pushOut.send(lightMsg);
        }
    }

    //Function that clears the Push of stuck MIDI messages
    fun void clearQuad()
    {
        //CC numbers of misc. buttons 
        [28, 86, 116, 117, 118, 119, 3, 114, 115, 113, 112, 43, 42, 41, 40, 39, 38, 37, 36] @=> int misc[];

        //For loop to clear the pads
        for (36 => int i; i<100; i++)
        {
            144 => lightMsg.data1;
            i => lightMsg.data2;
            0 => lightMsg.data3;
            pushOut.send(lightMsg);
        }
        //For loop to clear the top row of small buttons
        for (20 => int j; j<28; j++)
        {
            176 => lightMsg.data1;
            j => lightMsg.data2;
            0 => lightMsg.data3;
            pushOut.send(lightMsg);
        }
        //For loop to clear the second row of small buttons
        for (102 => int k; k<110; k++)
        {
            176 => lightMsg.data1;
            k => lightMsg.data2;
            0 => lightMsg.data3;
            pushOut.send(lightMsg);
        }
        //For loop to clear all the misc. buttons
        for (int l; l<misc.cap(); l++)
        {
            176 => lightMsg.data1;
            misc[l] => lightMsg.data2;
            0 => lightMsg.data3;
            pushOut.send(lightMsg);
        }
        //Clear the screen
        p.clearScreen();
    }
    
    //Function that controls the LiSa object playback rates using the information coming from that rotaries
    fun void rateControl()
    {
        while (true)
        {
            0.1 + (r.value0x2*10) => l1.rate;
            0.1 + (r.value2x2*10) => l2.rate;
            0.1 + (r.value4x2*10) => l3.rate;
            0.1 + (r.value6x2*10) => l4.rate;
            
            //Refresh rate
            20::ms => now;
        }
    }
    
    //Function that controls the Pan2 object volumes using the information coming from the rotaries
    fun void volumeControl()
    {
        while (true)
        {
            //Volume of each "zone"
            ch1.gain(r.value1x2);
            ch2.gain(r.value3x2);
            ch3.gain(r.value5x2);
            ch4.gain(r.value7x2);

            //Volume of each LiSa
            lisa1vol.gain(r.value1x2);
            lisa2vol.gain(r.value3x2);
            lisa3vol.gain(r.value5x2);
            lisa4vol.gain(r.value7x2);

            //Volume of global "LiSa Buss"
            lisaBuss.gain(r.valueRx2);

            //Master Volume
            master.gain(r.value8x2);
            
            //Refresh rate
            20::ms => now;
        }
    }
    
    //Function that loads samples and sets play heads for each SndBuf 
    fun void loadSamples ()
    {
        //Setting filepaths for each SndBuf
        me.dir() + "/audio/clap_01.wav"      => clap.read;
        me.dir() + "/audio/click_01.wav"     => click1.read;
        me.dir() + "/audio/click_02.wav"     => click2.read;
        me.dir() + "/audio/click_03.wav"     => click3.read;
        me.dir() + "/audio/click_04.wav"     => click4.read;
        me.dir() + "/audio/click_05.wav"     => click5.read;
        me.dir() + "/audio/cowbell_01.wav"   => cowbell.read;
        me.dir() + "/audio/hihat_01.wav"     => hat1.read;
        me.dir() + "/audio/hihat_02.wav"     => hat2.read;
        me.dir() + "/audio/hihat_03.wav"     => hat3.read;
        me.dir() + "/audio/hihat_04.wav"     => hat4.read;
        me.dir() + "/audio/kick_01.wav"      => kik1.read;
        me.dir() + "/audio/kick_02.wav"      => kik2.read;
        me.dir() + "/audio/kick_03.wav"      => kik3.read;
        me.dir() + "/audio/kick_04.wav"      => kik4.read;
        me.dir() + "/audio/kick_05.wav"      => kik5.read;
        me.dir() + "/audio/snare_01.wav"     => snr1.read;
        me.dir() + "/audio/snare_02.wav"     => snr2.read;
        me.dir() + "/audio/snare_03.wav"     => snr3.read;
        me.dir() + "/audio/stereo_fx_01.wav" => fx1.read;
        me.dir() + "/audio/stereo_fx_02.wav" => fx2.read;
        me.dir() + "/audio/stereo_fx_03.wav" => fx3.read;
        me.dir() + "/audio/stereo_fx_04.wav" => fx4.read;
        me.dir() + "/audio/stereo_fx_05.wav" => fx5.read;
        
        //Set the playheads of each of the SndBuf's to the end of the sample
        clap.samples()    => clap.pos;
        click1.samples()  => click1.pos;
        click2.samples()  => click2.pos;
        click3.samples()  => click3.pos;
        click4.samples()  => click4.pos;
        click5.samples()  => click5.pos;
        cowbell.samples() => cowbell.pos;
        hat1.samples()    => hat1.pos;
        hat2.samples()    => hat2.pos;
        hat3.samples()    => hat3.pos;
        hat4.samples()    => hat4.pos;
        kik1.samples()    => kik1.pos;
        kik2.samples()    => kik2.pos;
        kik3.samples()    => kik3.pos;
        kik4.samples()    => kik4.pos;
        kik5.samples()    => kik5.pos;
        snr1.samples()    => snr1.pos;
        snr2.samples()    => snr2.pos;
        snr3.samples()    => snr3.pos;
        fx1.samples()     => fx1.pos;
        fx2.samples()     => fx2.pos;
        fx3.samples()     => fx3.pos;
        fx4.samples()     => fx4.pos;
        fx5.samples()     => fx5.pos;    
    }

    //SOUND HANDLER //////////////////////////////////////////////////////////////
    
    //Function that handles the playback of SndBuf's
    //Accepts three arguments - SndBuf, sample length, velocity (between 0 & 1)
    fun void sampHandler(SndBuf input, float gateTime, float velocity)
    {
        ((velocity + 0.3) * 2.5) => float scaledVel;

        scaledVel => input.rate;
        0 => input.pos;
        gateTime::second => now;
        input.samples() => input.pos;

        me.exit();
    }

    //MELODY GENERATOR ////////////////////////////////////////////////////////////
    
    //Function that creates a number of arrays of generated melodies from a scale
    fun int[][] melodyMaker (int intervals[])
    {
        [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] @=> int scales[][];
        
        for (int i; i<4; i++)
        {
            for (int j; j<20; j++)
            {
                intervals[Math.random2(0, intervals.cap()-1)] => scales[i][j];
            }
        }
        return scales;
    }
    
    //UTILITY FUNCTIONS ////////////////////////////////////////////////////////////
    
    //Overloaded function that returns which quad a given note is in for its x and y
    fun int XYtoQuad (int x, int y)
    {
        int ans;
        
        if      (x>=0 && x<=3 && y>=0 && y<=3) {1 => ans;}
        else if (x>=4 && x<=7 && y>=0 && y<=3) {2 => ans;}
        else if (x>=4 && x<=7 && y>=4 && y<=7) {3 => ans;}
        else if (x>=0 && x<=3 && y>=4 && y<=7) {4 => ans;}
        
        return ans;
        
    }
    //Overloaded function that returns which quad a given note is in for its x and y
    fun int XYtoQuad (int xy[])
    {
        xy[0] => int x;
        xy[1] => int y;
        int ans;
        
        if      (x>=0 && x<=3 && y>=0 && y<=3) {1 => ans;}
        else if (x>=4 && x<=7 && y>=0 && y<=3) {2 => ans;}
        else if (x>=4 && x<=7 && y>=4 && y<=7) {3 => ans;}
        else if (x>=0 && x<=3 && y>=4 && y<=7) {4 => ans;}
        
        return ans;
    }
    
    //Overloaded function that returns MIDI note number for an (x,y) position on Push pads
    fun int XYtoM (int x, int y)
    {
        //MIDI note number of (0,0)
        92 => int origin;
        0 => int addme;
        0 => int ans;
        
        0 - (y*8) => addme;
        addme + x => addme;
        origin + addme => ans;
        return ans;
    }
    
     //Overloaded function that returns MIDI note number for an (x,y) position on Push pads
    fun int XYtoM (int xy[])
    {
        xy[0] => int x;
        xy[1] => int y;

        //MIDI note number of (0,0)
        92 => int origin;
        0 => int addme;
        0 => int ans;
        
        0 - (y*8) => addme;
        addme + x => addme;
        origin + addme => ans;
        return ans;
    }

    //Returns (x,y) position for a MIDI note number on Push pads
    fun int[] MtoXY (int note)
    {
        int x;
        int y;
        [0,0] @=> int xy[];
        
        if (note >= 36 && note <= 43) {(note+4)%8 => x; 7 =>  y;}
        if (note >= 44 && note <= 51) {(note+4)%8 => x; 6 =>  y;}
        if (note >= 52 && note <= 59) {(note+4)%8 => x; 5 =>  y;}
        if (note >= 60 && note <= 67) {(note+4)%8 => x; 4 =>  y;}
        if (note >= 68 && note <= 75) {(note+4)%8 => x; 3 =>  y;}
        if (note >= 76 && note <= 83) {(note+4)%8 => x; 2 =>  y;}
        if (note >= 84 && note <= 91) {(note+4)%8 => x; 1 =>  y;}
        if (note >= 92 && note <= 99) {(note+4)%8 => x; 0 =>  y;}
        else if (note > 99 || note < 36) {<<< "Check input arguments of MtoXY!" >>>;}
        
        x => xy[0];
        y => xy[1];
        
        return xy;
    }  
}
//TEST ///////////////////////////////////////////////////////
TheQuad q;

q.playQuad();