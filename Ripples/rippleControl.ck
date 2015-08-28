<<<"rippleControl.ck by Mike Leisz, 12/01/14">>>;

//generative ripple based glitch sequencer
//primary shred for composition control
//handles time, cell states, instantiation of instruments and ripples

//midiIn message
MidiIn min;
MidiMsg msg;
if (!min.open(0)) me.exit(); //open midi port
<<< "MIDI device:  - ", min.num(), " -> ", min.name() >>>;

//master clock
.15::second => dur sixteenth;
sixteenth/4 => dur tick;

int _numX, _numY;
8 => _numX; //enter grid width
8 => _numY; //enter grid height

//grid of cells
Cell _cells[_numX][_numY];

//dynamic array of ripple objects
Ripple _ripples[0];
4 => int maxRipples; //maximum simultaneous ripples

Rippler r; //rippler object, controls nearly all composition parameters

Grain _grains[0]; //dynamic glitch sample array
Pan2 grainGain => dac; //gain object for all glitch samples

GenOsc _oscs[0]; //dynamic array of oscillators
Pan2 oscGain => dac; //gain objects for all osc objects

//liSa sampler parameters
time past, present;
dur loopLength; //dur vars for liSa loop length
dac => LiSa loop => GlitchDelay glitch => dac; //liSa samples dac output
spork ~ glitch.update();
2::second => loop.duration;
1 => loop.loop;
1 => loop.bi;

spork ~ midiListen(r); //spork midi listener

["kick","snare","hihat","click","stereo_fx"] @=> string samples[]; //array of filenames for samples

while (true){
    r.update(); //update rippler
    
    for (int i; i < _ripples.cap(); i++){
        _ripples[i].counter++; //iterate counter on all active ripples
    }
    
    //modulate instrument pans
    Math.sin((now/(tick*4))*pi) => grainGain.pan;
    Math.cos((now/(tick*4))*pi) => oscGain.pan;
    
    tick => now; //update clock
}

fun void midiListen(Rippler myRippler){
    while (true){
        min => now;
        while (min.recv(msg)){
            if (msg.data1 == 144){
                
                now => past;
                1 => loop.record; //record liSa on midi noteOn
                
                if (_ripples.cap() < maxRipples){ //if ripple count < max ripple count
                    myRippler.addRipple(msg.data3); //add new ripple on midi noteOn
                } else {
                    myRippler.checkAge(_ripples); //else check for oldest ripple and delete
                    myRippler.addRipple(msg.data3); //then add new ripple
                }
            }
            if (msg.data1 == 128){
                
                now => present;
                0 => loop.record;
                1 => loop.play; //playback liSa on midi noteOff
                
                present - past => loopLength;
                loop.loopEnd(loopLength);
            }
            
            //various instrument parameters mapped to knobs
            if (msg.data1 == 176 && msg.data2 == 1 && msg.data3 != 0){
                lisaRate(msg.data3) => loop.rate;
            }
            if (msg.data1 == 176 && msg.data2 == 2 && msg.data3 != 0){
                1.0 * msg.data3 / 127 => loop.gain;
            }
            if (msg.data1 == 176 && msg.data2 == 3 && msg.data3 != 0){
                1.0 * msg.data3 / 127 => grainGain.gain;
            }
            if (msg.data1 == 176 && msg.data2 == 4 && msg.data3 != 0){
                (2.0 * msg.data3 / 127)::second => loop.loopEnd;
            }
            if (msg.data1 == 176 && msg.data2 == 5 && msg.data3 != 0){
                1.0 * msg.data3 / 127 => oscGain.gain;
            }
        }
    }
}

fun void lisaControl(){
    float f;
    while (true){
        min => now;
        while (min.recv(msg)){
            if (msg.data1 == 176 && msg.data2 == 1){
                lisaRate(msg.data3) => loop.rate;
            }
        }
        if (Math.randomf() > .99){
            loop.clear();
        }
    }
}

fun float lisaRate(int msgData){
    float result;
    (10) * msgData / 127 => result;
    return result;
}

public class Rippler{
    
    initGrid(); //create grid
    
    fun void initGrid(){
        
        //build cell grid
        new Cell[_numX][_numY] @=> _cells;
        for (int x; x < _numX; x++){
            for (int y; y < _numY; y++){
                Cell newCell;
                x => newCell.x;
                y => newCell.y;
                newCell @=> _cells[x][y];
            }
        }
        
        //check edges
        for (int x; x < _numX; x++){
            for (int y; y < _numY; y++){
                y - 1 => int above;
                y + 1 => int below;
                x - 1 => int left;
                x + 1 => int right;
                
                if (above < 0){
                    1 => _cells[x][y].edge;
                }
                if (below == _numY){
                    1 => _cells[x][y].edge;
                }
                if (left < 0){
                    1 => _cells[x][y].edge;
                }
                if (right == _numX){
                    1 => _cells[x][y].edge;
                }
            }
        }
    }
    
    //add new ripple
    //takes midi note velocity and maps to propagration speed
    fun void addRipple(int vel){
        Ripple rip;
        Math.random2(0,8) + 0.5 => rip.centerX; //place ripple randomly on grid
        Math.random2(0,8) + 0.5 => rip.centerY;
        (rip.durs.cap() - 1) * vel / 127 => int thisBeat; //map velocity to speed
        rip.durs[thisBeat] => rip.myDur;
        _ripples << rip;
        
        Grain g; //add new glitch sample object with ripple
        g.loadSample(me.dir(-1) 
        + "/audio/" + samples[Math.random2(0, samples.cap() - 1)] + "_0" + Math.random2(1,3) + ".wav");
        g.chuckSample(grainGain);
        spork ~ g.play(8, (tick/second * rip.myDur)::second);
        _grains << g;
    }
    
    //never used, duplicate of code inside main time loop
    fun void run(){
        while (true){
            r.update();
            
            for (int i; i < _ripples.cap(); i++){
                _ripples[i].counter++;
            }
            
            tick => now;
        }
    }
    
    //rippler update function, updates ripples and cells
    fun void update(){
        
        for (int x; x < _numX; x++){
            for (int y; y < _numY; y++){
                _cells[x][y].calcNextState();
            }
        }
        
        for (int i; i < _ripples.cap(); i++){
            if (_ripples[i].counter % _ripples[i].myDur == 0){
                _ripples[i].update();
                
                if (_ripples[i].r > _numX){
                    removeIndex(_ripples, i); //remove ripple if at max radius
                    removeGrain(_grains, i); //remove glitch object as well
                } else {
                    0 => _ripples[i].counter;
                }
            }
        }
        
        getStates(); //get cell states
        checkCollisions(); //check ripple collisions
        
        //update cells
        for (int x; x < _numX; x++){
            for (int y; y < _numY; y++){
                _cells[x][y].update();
                _cells[x][y].display();
            }
        }
        
        //print cell grid
        <<<_cells[0][0].state, _cells[1][0].state, _cells[2][0].state, _cells[3][0].state, _cells[4][0].state, _cells[5][0].state, _cells[6][0].state, _cells[7][0].state>>>;
        <<<_cells[0][1].state, _cells[1][1].state, _cells[2][1].state, _cells[3][1].state, _cells[4][1].state, _cells[5][1].state, _cells[6][1].state, _cells[7][1].state>>>;
        <<<_cells[0][2].state, _cells[1][2].state, _cells[2][2].state, _cells[3][2].state, _cells[4][2].state, _cells[5][2].state, _cells[6][2].state, _cells[7][2].state>>>;
        <<<_cells[0][3].state, _cells[1][3].state, _cells[2][3].state, _cells[3][3].state, _cells[4][3].state, _cells[5][3].state, _cells[6][3].state, _cells[7][3].state>>>;
        <<<_cells[0][4].state, _cells[1][4].state, _cells[2][4].state, _cells[3][4].state, _cells[4][4].state, _cells[5][4].state, _cells[6][4].state, _cells[7][4].state>>>;
        <<<_cells[0][5].state, _cells[1][5].state, _cells[2][5].state, _cells[3][5].state, _cells[4][5].state, _cells[5][5].state, _cells[6][5].state, _cells[7][5].state>>>;
        <<<_cells[0][6].state, _cells[1][6].state, _cells[2][6].state, _cells[3][6].state, _cells[4][6].state, _cells[5][6].state, _cells[6][6].state, _cells[7][6].state>>>;
        <<<_cells[0][7].state, _cells[1][7].state, _cells[2][7].state, _cells[3][7].state, _cells[4][7].state, _cells[5][7].state, _cells[6][7].state, _cells[7][7].state>>>;
    }
    
    //dynamically remove grain objects
    fun void removeGrain(Grain grains[], int index){
        grains[index].kill(grainGain);
        for (int i; i < grains.cap(); i++){
            if (i > index){
                grains[i] @=> grains[i - 1];
            }
        }
        grains.popBack();
    }
    
    //dynamically remove ripple objects
    fun void removeIndex(Ripple rips[], int index){
        for (int i; i < rips.cap(); i++){
            if (i > index){
                rips[i] @=> rips[i - 1];
            }
        }
        rips.popBack();
    }
    
    //check for oldest ripple
    fun void checkAge(Ripple rips[]){
        -1 => int peak;
        -1 => int peakValue;
        for (int i; i < rips.cap(); i++){
            if (rips[i].counter > peakValue){
                rips[i].counter => peakValue;
                i => peak;
            }
        }
        removeIndex(rips, peak);
        removeGrain(_grains, peak);
    }
    
    //check if ripples are colliding
    fun void checkCollisions(){
        for (int i; i < _ripples.cap(); i++){
            for (int j; j < _ripples.cap(); j++){
                if (i != j){
                    Math.hypot(_ripples[j].centerX - _ripples[i].centerX, 
                    _ripples[j].centerY - _ripples[i].centerY) => float dist;
                    
                    dist - _ripples[i].r - _ripples[j].r => float overlap;
                    
                    //if colliding, create new melody object
                    //feed melody object various ripple qualities as parameters
                    if (overlap < 0){
                        if (_ripples[i].hasCollided == false && _ripples[j].hasCollided == false){
                            true => _ripples[i].collision;
                            GenOsc go;
                            go.chuckOsc(oscGain);
                            (_ripples[i].centerX + _ripples[j].centerX + 1) $ int => int iX;
                            (_ripples[i].centerY + _ripples[j].centerY + 1) $ int => int iY;
                            go.init(tick/second * (_ripples[i].myDur / _ripples[j].myDur), iX, iY, _ripples[i].r);
                            
                            true => _ripples[i].hasCollided;
                            true => _ripples[j].hasCollided;
                        }
                    }
                }
            }
        }
    }
    
    //check ripples on grid, adjust cell states accordingly
    fun void getStates(){
        for (int i; i < _ripples.cap(); i++){            
            
            for (int cellX; cellX < _numX; cellX++){
                for (int cellY; cellY < _numY; cellY++){
                    //x less than equal to, y less than equal to
                    if (_cells[cellX][cellY].x <= _ripples[i].centerX && _cells[cellX][cellY].y <= _ripples[i].centerY){
                        if (Math.pow((_cells[cellX][cellY].x - _ripples[i].centerX), 2) +
                        Math.pow((_cells[cellX][cellY].y - _ripples[i].centerY), 2) >= Math.pow(_ripples[i].r, 2) &&
                        Math.pow(((_cells[cellX][cellY].x + 1) - _ripples[i].centerX), 2) +
                        Math.pow(((_cells[cellX][cellY].y + 1) - _ripples[i].centerY), 2) < Math.pow(_ripples[i].r, 2)){
                            
                            1 => _cells[cellX][cellY].nextState;
                        }
                    }
                    //x greater than equal to, y greater than equal to
                    if (_cells[cellX][cellY].x >= _ripples[i].centerX && _cells[cellX][cellY].y >= _ripples[i].centerY){
                        if (Math.pow((_cells[cellX][cellY].x - _ripples[i].centerX), 2) +
                        Math.pow((_cells[cellX][cellY].y - _ripples[i].centerY), 2) < Math.pow(_ripples[i].r, 2) &&
                        Math.pow(((_cells[cellX][cellY].x + 1) - _ripples[i].centerX), 2) +
                        Math.pow(((_cells[cellX][cellY].y + 1) - _ripples[i].centerY), 2) >= Math.pow(_ripples[i].r, 2)){
                            
                            1 => _cells[cellX][cellY].nextState;
                        }
                    }
                    // x greater than, y less than
                    if (_cells[cellX][cellY].x > _ripples[i].centerX && _cells[cellX][cellY].y < _ripples[i].centerY){
                        if (Math.pow((_cells[cellX][cellY].x - _ripples[i].centerX), 2) +
                        Math.pow(((_cells[cellX][cellY].y + 1) - _ripples[i].centerY), 2) < Math.pow(_ripples[i].r, 2) &&
                        Math.pow(((_cells[cellX][cellY].x + 1) - _ripples[i].centerX), 2) +
                        Math.pow((_cells[cellX][cellY].y - _ripples[i].centerY), 2) >= Math.pow(_ripples[i].r, 2)){
                            
                            1 => _cells[cellX][cellY].nextState;
                        }
                    }
                    // x less than, y greater than
                    if (_cells[cellX][cellY].x < _ripples[i].centerX && _cells[cellX][cellY].y > _ripples[i].centerY){
                        if (Math.pow(((_cells[cellX][cellY].x + 1) - _ripples[i].centerX), 2) +
                        Math.pow((_cells[cellX][cellY].y - _ripples[i].centerY), 2) < Math.pow(_ripples[i].r, 2) &&
                        Math.pow((_cells[cellX][cellY].x - _ripples[i].centerX), 2) +
                        Math.pow(((_cells[cellX][cellY].y + 1) - _ripples[i].centerY), 2) >= Math.pow(_ripples[i].r, 2)){
                            
                            1 => _cells[cellX][cellY].nextState;
                        }
                    }
                }
            }
        }
    }
}

//cell object, stores grid of states (0 or 1)
class Cell{
    float x, y;
    
    int state;
    int nextState;
    
    int edge;
    
    fun void calcNextState(){
        if (state > 0){
            state - 1 => nextState;
        }
    }
    
    //update cell state once all states are evaluated
    fun void update(){
        nextState => state;
    }
    
    //this function was never used
    //some kind of pad control function
    fun void display(){
        if (state > 1){
            //do something
        } else if (state == 1){
            
            //do something
        } else {
            
            //do something
            //pad off
        }
        
        if (edge > 0){
            if (state > 0){
                
                //do something
                //there is a more elegant 
                //and purposeful way to do this
            }
        }
    }
}