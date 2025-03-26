#include  <stdlib.h>
#include  <stdio.h>
#include  <math.h>

/* 

list de indicativos RJ/BR
PU1- JAA a YZZ

*/

static const char *alpha[] = {
    ".-",   //A
    "-...", //B
    "-.-.", //C
    "-..",  //D
    ".",    //E
    "..-.", //F
    "--.",  //G
    "....", //H
    "..",   //I
    ".---", //J
    "-.-",  //K
    ".-..", //L
    "--",   //M
    "-.",   //N
    "---",  //O
    ".--.", //P
    "--.-", //Q
    ".-.",  //R
    "...",  //S
    "-",    //T
    "..-",  //U
    "...-", //V
    ".--",  //W
    "-..-", //X
    "-.--", //Y
    "--..", //Z
};

static const char *num[] = {
    "-----", //0
    ".----", //1
    "..---", //2
    "...--", //3
    "....-", //4
    ".....", //5
    "-....", //6
    "--...", //7
    "---..", //8
    "----.", //9
};

static const char * phone[] = {
"Alfa",
"Bravo",
"Charlie",
"Delta",
"Echo",
"Foxtrot",
"Golf",
"Hotel",
"India",
"Juliett",
"Kilo",
"Lima",
"Mike",
"November",
"Oscar",
"Papa",
"Quebec",
"Romeo",
"Sierra",
"Tango",
"Uniform",
"Victor",
"Whiskey",
"X-ray",
"Yankee",
"Zulu"
};


/*

',' (comma = “–..–“) and '.' (period = “.-.-.-“).



*/

int main ( int argc, char * argv[]) {

int i, j, k, n;

for (i='J'; i<'Z'; i++) {
        for (j='A'; j<='Z'; j++) {
                for (k='A'; k<='Z'; k++) {
    
        printf (" %c %c %c %s %s %s %s %s %s\n", 
		(char) i, (char) j, (char) k,
		phone[i-'A'], phone[j-'A'], phone[k-'A'],
		alpha[i-'A'], alpha[j-'A'], alpha[k-'A']);

                }
        }
    }

return (0);
}

