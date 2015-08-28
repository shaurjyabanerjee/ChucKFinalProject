//Print on Push's screen over SysEx
//Shaurjya Banerjee - 11/06/2014


//The PushScreen class has three member functions you may want to call-

//1. .printScreen() - Use this function to print on the Push screen. Accepts 4 (17X4) 2D arrays as arguments
//2. .clearScreen() - Use this function to clear the entire screen at once
//3. .clearLine()   - Use this function to clear a single line at a time. Accepts a line number (1-4) as an argument


public class PushScreen
{
    PushPort p;
    p.look();
    
    //SCREEN CHARACTER HANDLING - Shaurjya Banerjee - 11/1/2014 ////////////////////////////////
    
    //Dummy 17x4 2D int arrays to hold the ASCII numbers for the screen's 4 "blocks"
    [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] @=> int B1ascii[][];
    [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] @=> int B2ascii[][];
    [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] @=> int B3ascii[][];
    [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] @=> int B4ascii[][];
    
    //The final 77x4 byte sysex message in a single 77x4 2d integer array

    //|<----Sysex---->|<--line-->||<-sysex->||<-------screen block 1 ASCII ---->| |<-------screen block 2 ASCII---->| |<-------screen block 3 ASCII---->|  |<-------screen block 4 ASCII---->||<-sysex>| 
    [[240, 71, 127, 21,     24,     0, 69, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    247  ], 
     [240, 71, 127, 21,     25,     0, 69, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    247  ], 
     [240, 71, 127, 21,     26,     0, 69, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    247  ], 
     [240, 71, 127, 21,     27,     0, 69, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    247  ]] @=> int finalMsg[][];
    
    //Four 77 element dummy int arrays which will be sent to Push's screen
    [  0,  0,   0,  0,      0,     0,  0, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0    ] @=> int final1[];
    [  0,  0,   0,  0,      0,     0,  0, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0    ] @=> int final2[];
    [  0,  0,   0,  0,      0,     0,  0, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0    ] @=> int final3[];
    [  0,  0,   0,  0,      0,     0,  0, 0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    0    ] @=> int final4[];
    
    //Function that takes the (17x4) array of string characters and translates them into ASCII numbers in an integer 17x4 array. 
    fun void char2ascii ( string input [][], int dest [][] )
    {
        //Two arrays of the same length which hold characters and their corresponding ASCII values
        [" ","!","#","$","%","&","'","(",")","*","+",",","-",".","/","0","1","2",
        "3","4","5","6","7","8","9",":",";","<","=",">","?","@","A","B","C","D",
        "E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V",
        "W","X","Y","Z","[","]","^","_","a","b","c","d","e","f","g","h","i","j",
        "k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","{","|","}","~"] @=> string charList[];

        [ 32, 33, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 
        51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 
        69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 
        87, 88, 89, 90, 91, 93, 94, 95, 97, 98, 99,100,101,102,103,104,105,106,
        107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126] @=> int asciiList[];
        
        int ascii;
        string test;
        
        for (int y; y<4; y++)
        {
            for (int x; x<17; x++)
            {
                for (int i; i<asciiList.cap(); i++)
                {
                    if (input[y][x] == charList[i])
                    {
                        charList[i] => test;
                        asciiList[i] => ascii;
                        ascii => dest[y][x];    
                    }
                }
            } 
        }
    }
    
    //Function that takes four 2D integer arrays of ASCII characters and turns them into the final 77x4 sysex message
    fun void screenMsg (int zero[][], int one[][], int two[][], int three[][])
    {
        for (int line; line<4; line ++)
        {
            for (int i; i<4; i++)
            {
                for (int j; j<17; j++)
                {
                    if (i == 0) {zero[line][j] => finalMsg[line][j+8];}
                    else if (i == 1) {one[line][j] => finalMsg[line][j+25];}
                    else if (i == 2) {two[line][j] => finalMsg[line][j+42];}
                    else if (i == 3) {three[line][j] => finalMsg[line][j+59];}
                }
            }
        }
    }
    
    //Function that converts the 77x4 2D array into 4 1D arrays
    fun void twoDoneD ( int fullMsg[][] )
    {
        for (int i; i<4; i++)
        {
            for (int j; j<77; j++)
            {
                if (i == 0) {fullMsg[i][j] => final1[j];}
                else if (i == 1) {fullMsg[i][j] => final2[j];}
                else if (i == 2) {fullMsg[i][j] => final3[j];}
                else if (i == 3) {fullMsg[i][j] => final4[j];}
            }
        }
    }
    
    //MIDI SysEx - Bruce Lott & Ness Morris - 08/12/2013 ////////////////////////////////////////
    
    MidiOut mout;
    MidiMsg msgs[];
    
    fun void openPort (int port)
    {
        mout.open(port);
    }
    fun void openPort (string portName)
    {
        mout.open(portName);
    }
    
    fun void send (int bytes[])
    {
        bytes.cap()/3 => int numMsgs;
        if (Math.remainder(bytes.cap(), 3)) numMsgs++;
        new MidiMsg[numMsgs] @=> msgs;
        
        for ( int i; i<bytes.cap(); i++)
        {
            if (i%3 == 0) {bytes[i] => msgs[(i/3)].data1;}
            else if (i%3 == 1) {bytes[i] => msgs[(i/3)].data2;}
            else if (i%3 == 2) {bytes[i] => msgs[(i/3)].data3;}
        }
        
        for (int i; i<msgs.cap(); i++)
        {
            mout.send(msgs[i]);
        }
    }
    
    //Main Functions - Shaurjya Banerjee - 11/06/2014 /////////////////////////////////////////
    
    //Function that calls all the other functions required to print on Push's screen
    fun void printScreen (string screenB1[][], string screenB2[][], string screenB3[][], string screenB4[][])
    { 
        openPort(p.userPort);
        char2ascii (screenB1, B1ascii);
        char2ascii (screenB2, B2ascii);
        char2ascii (screenB3, B3ascii);
        char2ascii (screenB4, B4ascii);
        
        screenMsg ( B1ascii, B2ascii, B3ascii, B4ascii );
        twoDoneD (finalMsg);
        
        send (final1);
        send (final2);
        send (final3);
        send (final4);  
    }

    //Function that clears the entire Push screen
    fun void clearScreen()
    {
        [240, 71, 127, 21,     28, 0, 0, 247] @=> int clearLine1[];
        [240, 71, 127, 21,     29, 0, 0, 247] @=> int clearLine2[];
        [240, 71, 127, 21,     30, 0, 0, 247] @=> int clearLine3[];
        [240, 71, 127, 21,     31, 0, 0, 247] @=> int clearLine4[];
        
        openPort(p.userPort);
        send (clearLine1);
        send (clearLine2);
        send (clearLine3);
        send (clearLine4);
    }

    //Function that clears a single line of the Push screen. Accepts line number as an argument
    fun void clearLine(int line)
    {
        [240, 71, 127, 21,     28, 0, 0, 247] @=> int clearLine1[];
        [240, 71, 127, 21,     29, 0, 0, 247] @=> int clearLine2[];
        [240, 71, 127, 21,     30, 0, 0, 247] @=> int clearLine3[];
        [240, 71, 127, 21,     31, 0, 0, 247] @=> int clearLine4[];
        
        openPort(p.userPort);
        
        if (line == 1) {send(clearLine1);}
        if (line == 2) {send(clearLine2);}
        if (line == 3) {send(clearLine3);}
        if (line == 4) {send(clearLine4);}
    }
}

