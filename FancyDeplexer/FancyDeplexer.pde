//      -=- Angular Deplexer -=-
// A little chip to take multiplexed PPM
//  signals, and split them up over the
//   digital pins, for RC things, and
//   fun little cassette tape robots!
//                             <3 Bluebie

// And now for some settings...
#define outputs 4
#define first_output 2
#define reset_gap_minimum 2000

// Just a few little variables to keep our head on straight...
//unsigned char iter = 0;

void setup() {
  unsigned char iter;
  for (iter = 0; iter < outputs; iter++) pinMode(iter, OUTPUT);
  
  // setup the analog comparitor
  // see http://www.bot-thoughts.com/2010/09/arduino-avr-analog-comparator.html
  //pinMode(6, INPUT);
  //pinMode(7, INPUT);
  // ACD=0, ACBG=0, ACO=0 ACI=0 ACIE=0 ACIC=0 ACIS1, ACIS0
  // - interrupt on output toggle
  ACSR = 0b00000000;
  // ADEN=1
  ADCSRA = 0b10000000;
  // ACME=0 (on) ADEN=0 MUX = b000 for use of AIN1
  ADCSRB = 0b00000000;
}

unsigned long counter = 0;
unsigned long pollComparatorUntil(bool value) {
  counter = 1;
  while (((ACSR & 0b00100000) > 1) != value) {
    counter++;
  }
  return counter;
}

unsigned char output = first_output;
#define setOutput(state) if (output < first_output + outputs) digitalWrite(output, state);
unsigned long gap = 0;
void loop() {
  pollComparatorUntil(LOW); // wait till the thingy goes low (i.e. pulse done!)
  gap = pollComparatorUntil(HIGH); // wait till it does high, and then...
  setOutput(LOW); // turn off the last servo
  output++; // change to the next one!
  if (gap > reset_gap_minimum) output = first_output;
  setOutput(HIGH); // and turn it on, then wait till the next pulse to change over again!
}
