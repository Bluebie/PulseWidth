//      -=- Angular Deplexer -=-
// A little chip to take multiplexed PPM
//  signals, and split them up over the
//   digital pins, for RC things, and
//   fun little cassette tape robots!
//                             <3 Bluebie

// And now for some settings...
#define input 0
#define outputs 10
#define first_output 2
#define postgap 3

// Just a few little variables to keep our head on straight...
unsigned char iter = 0;

void setup() {
  // make our outputs all be outputty!
  for (iter = first_output; iter < first_output + outputs; iter++) {
    pinMode(iter, OUTPUT);
  }
  
  // setup the analog comparitor
  // see http://www.bot-thoughts.com/2010/09/arduino-avr-analog-comparator.html
  pinMode(6, INPUT);
  pinMode(7, INPUT);
  // ACD=0, ACBG=0, ACO=0 ACI=0 ACIE=0 ACIC=0 ACIS1, ACIS0
  // - interrupt on output toggle
  ACSR = 0b00000000;
  // ADEN=1
  ADCSRA = 0b10000000;
  // ACME=0 (on) ADEN=0 MUX = b000 for use of AIN1
  ADCSRB = 0b00000000;
}

#define pollComparatorUntil(value) while (((ACSR & 0b00100000) > 1) != value) { }

unsigned char output = first_output;
unsigned long previous_high = 0;
void loop() {
  pollComparatorUntil(HIGH);
  if (previous_high > millis() + postgap) output = first_output;
  digitalWrite(output, HIGH);
  previous_high = millis();
  
  pollComparatorUntil(LOW);
  digitalWrite(output, LOW);
  
  output += 1;
  if (output >= outputs + first_output) output = first_output;
}
