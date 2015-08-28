<<<"Generative Ripple Sequencer by Mike Leisz">>>;
<<<"12/01/14">>>;
<<<"ICOM201 Final Assignment, CalArts">>>;

Machine.add(me.dir() + "/glitchDelay.ck") => int glitch_id;
Machine.add(me.dir() + "/grainSample.ck") => int grain_id;
Machine.add(me.dir() + "/oscDelay.ck") => int oscDelay_id;
Machine.add(me.dir() + "/genOsc.ck") => int osc_id;
Machine.add(me.dir() + "/ripple.ck") => int ripple_id;
Machine.add(me.dir() + "/rippleControl.ck") => int control_id;

while (true){
    1::second => now;
}
