//Initialize file for "The Quad"
//Shaurjya Banerjee - 11/22/2014

//Set filepaths
me.dir() + "/PushPort.ck"      => string portPath;
me.dir() + "/FilterDelay.ck"   => string delayPath;
me.dir() + "/RotaryClass.ck"   => string rotaryPath;
me.dir() + "/SupersawClass.ck" => string supersawPath;
me.dir() + "/ScreenClass.ck"   => string screenPath;
me.dir() + "/TheQuadNew.ck"    => string quadPath;

//Machine Add the required files
Machine.add(portPath)     => int portID;
Machine.add(delayPath)    => int delayID;
Machine.add(rotaryPath)   => int rotaryID;
Machine.add(supersawPath) => int supersawID;
Machine.add(screenPath)   => int screenID;
Machine.add(quadPath)     => int quadID;

//Infinite time loop
while (true) {10::minute => now;}