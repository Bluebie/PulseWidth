//      -=- Angular Deplexer -=-
// A little chip to take multiplexed PPM
//  signals, and split them up over the
//   digital pins, for RC things, and
//   fun little cassette tape robots!
//                             <3 Bluebie

// And now for some settings...
#define input 0
#define outputs 4
#define first_output 2
#define postgap_multiplier 2

// Just a few little variables to keep our head on straight...
unsigned char iter = 0;

void setup() {
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  
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
  Serial.begin(9600);
}

unsigned long counter = 0;
#define pollComparatorUntil(value) counter = 1; while (((ACSR & 0b00100000) > 1) != value) { counter++; }

unsigned char output = first_output;
unsigned long last_low_gap = 1;
void loop() {
  pollComparatorUntil(HIGH);
  if (counter > (last_low_gap * postgap_multiplier)) {
    output = first_output;
    Serial.println('Reset!');
  } else {
    Serial.print("didn't reset! last_low_gap = ");
    Serial.print(last_low_gap);
    Serial.print(", counter = ");
    Serial.println(counter);
  }
  
  last_low_gap = counter;
  digitalWrite(output, HIGH);
  Serial.println(counter);
  
  pollComparatorUntil(LOW);
  digitalWrite(output, LOW);
  
  output += 1;
  if (output >= outputs + first_output) output = first_output;
}
