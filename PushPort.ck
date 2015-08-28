//Class that detects which port Push's User Port & Live Port appear on
//Shaurjya Banerjee - 11/17/2014

public class PushPort
{
    MidiIn portIn;
    MidiMsg portMsg;
    
    int count;
    int portNum;
    false => int foundIt;
    int userPort;
    int livePort;
    
    //Function that checks ports for the Push User Port
    fun void look()
    {
        while (foundIt != true)
        {
            portIn.open(count);
            
            //If statement that checks each port starting at 0
            //Till it finds a match for Ableton Push User Port
            if ( portIn.name()=="Ableton Push User Port")
            {
                portIn.num() => portNum;
                true => foundIt;
                portNum => userPort;
                userPort-1 => livePort; 
            }   
            count++;         
        }
    }   
}