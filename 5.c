#include <mega8.h>
#include <m8_128.h>
#include <stdio.h>
#include <string.h>

#define status_SIM PINB.0 // in
#define pwrkey PORTB.1    // out
#define check 0
#define open  1
#define crash 2
#define cln   3
#define read  1
#define write 0
#define pin_1 1
#define pin_2 2
#define pin_3 3
#define pin_4 4
#define pin_5 5
#define pin_6 6
#define in    0
#define out   1
#define low   0
#define high  1

#define TOIE1    2 // Timer1
#define TXEN     3 // UART TX enable

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 100
char rx_buffer[RX_BUFFER_SIZE];

volatile static struct {u8 flag;    // ����� ����� � �������� �����
                        u16 count;} // ��������
                        Timer[4];// ������� ��������

u8 text[11],get_phone[13],get_ready[6],buff[3],symb,iniflag = 1;
u8 Numb = 4,sim900=0,ATflag=1,push, pin;
bit state = 1,first = 1,fst=1,once_open=1,once_crash=1;
//u8 OK[]="OK";  buffer[3],
__eeprom u8 alarm = 0;
__flash u8 my_phone[] = "+79098450953"; // - ��� �������;   +79842837204
__flash u8 service[] = "+79037011111";  // ������� ������-������ ���
__flash u8 Ready[] = "Ready";           // �������� ��� sim900
__flash u8 start[] = "03";              // �������
__flash u8 stop[] = "04";               // ���������
__flash u8 unlock[] = "02";             // �������.
__flash u8 lock[] = "01";               // ������.
__flash u8 open_door[] = "door_open";
__flash u8 crash_door[] = "crash_sens";
__flash u8 error_cmd[] = "error_cmd";
__flash u8 car_lock[] = "car_lock";
__flash u8 car_unlock[] = "car_unlock";

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

interrupt [TIM1_OVF] void timer1_ovf_isr(void) {u8 i;
for(i=0;i!=Numb;i++){     // ����������� ������� ��������
  	 //if(Timer[i].flag == 0) continue; // ���� ����� �������� - ��������� ��������
	 if(Timer[i].count !=0) {   // ���� ������ �� ��������, �� ������� ��� ���.
        Timer[i].count --;	// ��������� ����� � ������ ���� �� �����.
      	                    }
         
   	 else {
          Timer[i].flag = 0 ;   // ��������� �� ����? ���������� ���� � �������� �����
          if((Timer[0].flag == 0)&&(Timer[1].flag == 0)&&
          (Timer[2].flag == 0)&&(Timer[3].flag == 0)) {TIMSK &= ~(1<<TOIE1);} // Timer1 off
      	  }
   	                }
 //TIMER1 has overflowed
 TCNT1H = 0xFE; //setup
 TCNT1L = 0x24;
                                               }
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void) {
    char status, data;
    status=UCSRA;
    data=UDR;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
        rx_buffer[rx_wr_index]=data;
        if (++rx_wr_index == RX_BUFFER_SIZE) {
            rx_wr_index=0;
                                             }; 
        if (++rx_counter == RX_BUFFER_SIZE) {
            rx_counter=0;
            rx_buffer_overflow=1;
                                            };
                                                                     };
                                              }

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void){
char data;
if (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
                  }
#pragma used-
#endif
// Declare your global variables here
void ini_avr(void){
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x02;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

//TIMER1 initialize - prescale:8
// WGM: 0) Normal, TOP=0xFFFF
// desired value: 1000Hz
// actual value: 1000,000Hz (0,0%)
 TCCR1B = 0x00; //stop
 TCNT1H = 0xFE; //setup
 TCNT1L = 0x24;
 OCR1AH = 0x01;
 OCR1AL = 0xDC;
 OCR1BH = 0x01;
 OCR1BL = 0xDC;
 ICR1H  = 0x01;
 ICR1L  = 0xDC;
 TCCR1A = 0x00;
 TCCR1B = 0x02; //start Timer
 
// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 19200
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x0C;   //19200 ��� xtal 4,0���
//UBRRL=0x23; //19200 ��� xtal 11,0592���

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
WDTCR=0x1F;
WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
// Global enable interrupts
#asm("sei")
}

void soft_delay(u16 ms, u8 i){
       Timer[i].count = ms;     // s
       Timer[i].flag = 1;
       TIMSK |= 1 << TOIE1;     // Timer1 on
                             }

void clean_rx_buff(void){ u8 i;// ������� ������ ������� ��������
                  for (i=0;i<RX_BUFFER_SIZE;i++){
                       rx_buffer[i] = '\0';      // <NULL>
                                                }
                        }

void clean_get_phone(void){ u8 i;// ������� ������ ��������� ������
                  for (i=0;i<13;i++){
                       get_phone[i] = '\0';      // <NULL>
                                                }
                          }

void clean(void){      // ������� ��� ������
     clean_rx_buff();  // ������� ������ �����
     buff[0] = '\0';   // <NULL>  ������ ����� � ���
     buff[1] = '\0';   // <NULL>  ������ ����� � ���
     sim900 = 2;       // ��� ���
     ATflag = 10;      // ������� ���
     iniflag = 1;      // ������� ��� SIM900
     first = 1;        // ������ ���� � ATflag == 10
     fst = 1;
     soft_delay(500,1);// ����� ��� ��������� ATflag == 10
                }

void chek_get (void){
            if(getchar() == 'O'){       // ���� O
               if(getchar() == 'K'){    // � ��������� �������������
                  ATflag++;
                  clean_rx_buff();      // ������� ������
                                   }
               first = 1;               // ��������� �������
               clean_rx_buff();
                                }
                    }

void SGPIO (u8 operation_r_w, u8 GPIO_pin, u8 function_in_out, u8 level){
  printf("AT+SGPIO=%d,%d,%d,%d\r\n",operation_r_w,GPIO_pin,function_in_out,level); // ������.��/���.
  clean_rx_buff();  // ������� ������
                                                                        }

void sms(void){
         if(fst == 1) {         // ������ ����
            printf("AT+CMGS="); // set sms
            putchar('"');
            printf(my_phone);   // �������
            putchar('"');
            printf("\r\n");     // CR LF
            soft_delay(500,0);  // delay 500ms
            soft_delay(5000,1); // delay 5s
            fst = 0;            // ������ �� ���������
                       }
         if (Timer[0].flag == 0) {
            //if(getchar() == '>'){   // �������
               puts(text);          // send err
               putsf("\x1A\x0D");   // SUB (CTRL + Z)
               if(sim900 == 7) {sim900++;}  // ����.���
               else {pin = cln;}    // ����.���
                                //}
                                 }
         if (Timer[1].flag == 0) {
             clean();               // ������� ��� ������
                                 }
              }

void ini_sim900(void){u8 t = 20;   //ms
switch (ATflag) {
case 1: {
         if(first){                // ������ ����
         putsf("AT+IPR=19200\r");  // set Baud Rate sim900
         soft_delay(t,0); // delay 10ms
         first = 0;
                  }
                  
         if(Timer[0].flag == 0) {
         //ATflag++;
         chek_get (); // ��������� ����� sim900
                                }
        }
break;
case 2: {
         if(first){         // ������ ����
         putsf("ATE0\r");   // stop echo
         soft_delay(t,0);  // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
        }
break;
case 3: {
         if(first){         // ������ ����
         putsf("ATV1\r");   // OK echo
         soft_delay(t,0);   // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
        }
break;
case 4: {
         if(first){            // ������ ����
         putsf("AT+CMEE=0\r"); // stop error code
         soft_delay(t,0);      // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
        }
break;
case 5: {
         if(first){            // ������ ����
         putsf("AT+CLIP=1\r"); // ��� enable
         soft_delay(t,0);      // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
        }
break;
case 6: {
         if(first){          // ������ ����
         printf("AT+CSCA="); // set sms-service number
         putchar('"');
         printf(service);    // ������� ������-������ ���
         putchar('"');
         printf("\r\n"); 
         soft_delay(t,0);    // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get ();    // ��������� ����� sim900
                                 }
        }
break;
case 7: {
         if(first){            // ������ ����
         putsf("AT+CSCB=1\r"); // stop Cell Broadcast
         soft_delay(t,0);      // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
        }
break;
case 8: {
         if(first){            // ������ ����
         putsf("AT+CMGF=1\r"); // text format sms
         soft_delay(t,0);      // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
        }
break;
case 9: {
         if(first){         // ������ ����
         printf("AT+CSCS="); // ��� ����
         putchar('"');
         printf("GSM"); 
         putchar('"');
         printf("\r\n");
         soft_delay(t,0);    // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
        }
break;
case 10: {
         if(first){           // ������ ����
         printf("AT+CMGDA="); // �������� ���� ���
         putchar('"');
         printf("DEL ALL"); 
         putchar('"');
         printf("\r\n");
         soft_delay(t,0);    // delay 10ms
         first = 0;
                  }
         if (Timer[0].flag == 0) {
             chek_get (); // ��������� ����� sim900
                                 }
         }
break;

default: {iniflag = 0; // ini_ok
          ATflag = 1;
         }
              }
                     }

void pwrkey_change (u8 i, u16 ms){
     pwrkey = i;       // �������� �� ������ reset: 1 - ���.; 0 - ����.
     soft_delay(ms,2); // delay �s 2� ������
                                 }

void key_repit(void){
     if(first){
        pwrkey_change(1,1200); // ���.������ �� 1200��
        first = 0;
              }
     if(Timer[2].flag == 0){
        pwrkey_change(0,2000); // ����.������ �� 2000��
        first = 1;             // ������ ���� � ATflag == 10
        push++;                // ����.�������
                           }
              }

void main(void){
ini_avr();

while (1){
#asm("wdr")
if (status_SIM) { // ���� sim900 �������:
switch (sim900){  // ������� ������������� ������ � ����� ���
case 0:{
        if (first){
        soft_delay(15000,1);     // delay 15s softtim �1
        first = 0;
                  }
        if(getchar() == 'l'){    // ���� l 
        symb = rx_rd_index;      // ���������� ������ l
        soft_delay(20,0);        // delay 20ms
        sim900 = 1;              // ����.���
        first = 1;
                            }
        if(Timer[1].flag == 0){  // ���� ���� SIM900 ����������
        sim900 = 100;            // ���� �� �����, �� ��������.
        first = 1;
                              }
       }
break;
case 1:{
   if (Timer[0].flag == 0){
       rx_rd_index = symb+2;   // ��������������� ������ l; call ready
       gets(get_ready, 5);     // ��������� �����
       if(memcmpf (get_ready, Ready, 5) == 0){ // � ���������� ��� � ����� ���������
          clean_rx_buff();     // ������� ������
          soft_delay(2000,1);  // delay 2s softtim �1
          sim900 = 2;          // ����.���
                                             }
       if(memcmpf (get_ready, Ready, 5) != 0){ // ���� �� ����� �� 15� + 20��
          clean_rx_buff();     // ������� ������
          sim900 = 100;        // ������������ sim900
                                             }
                          }
       }
break;
case 2:{
        ini_sim900();       // ������� � �������� ������������� sim900
        if((Timer[1].flag == 0)&&(iniflag == 1)){ // ���� �� 9���. �� ���������������
            sim900 = 100;                         // ������������ sim900
            first = 1;                            // ������ ���� � ������������
                                                }
        if(iniflag == 0){                         // ���������������
            sim900 = 3;                           // ����.���
                        }
       }
break;
case 3:{
if(getchar() == '"'){       // ���� ������� (0x22)
   symb = --rx_rd_index;    // ���������� ������ �������
   soft_delay(20,0);        // delay 20ms
   sim900 = 4;              // ����.���
                    }
       }
break;
case 4:{
   if (Timer[0].flag == 0){
       rx_rd_index = ++symb;   // ��������������� ������ �������
       gets(get_phone, 12);    // ��������� �����
/* ..cmp..(,,) ���������� ������������� ��������, ���� ������ �������� ������������ ������� 
�� ��������; 0, ���� ������ ����������, � ������������� ��������, ���� ������ ������ 
�� �������� ������� �� ������. */
       if(memcmpf (get_phone, my_phone, 12) == 0) { // � ���������� ��� � ����� ���������
          sim900 = 5;          // ����.���
          clean_get_phone();      // ������� ������
          rx_buffer[symb] = '\0'; // <NULL> ������� �������
          soft_delay(20,0);       // delay 20ms
                                                  }
       if(memcmpf (get_phone, my_phone, 12) == 1) { // ���� �� ��� ������� ������ �� 20��
          clean_rx_buff();      // ������� ������
          clean_get_phone();    // ������� ������
          sim900 = 3;           // ����.���
                                                  }
                          }
       }
break;
case 5:{
if (getchar() == '\n') {       // ������� LF (0x0A)
    symb = --rx_rd_index;      // ���������� ������ LF
    soft_delay(10,0);          // delay 10ms
    sim900 = 6;                // ����.���
                       }
if (Timer[0].flag == 0) {      // ���� �� 20�� �� ������ ����� ������
    clean_rx_buff();           // ������� ������
    sim900 = 3;                // ����.���
                        }
       }
break;
case 6:{
   if(Timer[0].flag == 0) { u8 i;
     rx_rd_index = ++symb;             // ��������������� ������ c LF
     gets(buff, 2);                    // ��������� �����
     if(memcmpf (buff, start, 2) == 0){// ���� ��� == 03
         SGPIO(write,pin_1,out,high);  // 1� ��� ������. �� ���. � ���.
         clean();                      // ������� ��� ������
                                      }
     else if(memcmpf (buff, stop, 2) == 0){   // ���� ��� == 04
         SGPIO(write,pin_1,out,low);   // 1� ��� ������. �� ���. � ����.
         clean();                      // ������� ��� ������
                                          }
     else if(memcmpf (buff, unlock, 2) == 0){ // ���� ��� == 02
           alarm = 0;                  // �������.����.
           for (i=0;i<11;i++){
             text[i] = car_unlock[i];  // �������� ����� ���
                             }
           sim900 = 7;                 // ���������� ���
                                            }
     else if(memcmpf (buff, lock, 2) == 0){ // ���� ��� == 01
           alarm = 1;                  // ������.����.
           for (i=0;i<11;i++){
             text[i] = car_lock[i];    // �������� ����� ���
                             }
           sim900 = 7;                 // ���������� ���
                                          }
     else {
           for (i=0;i<11;i++){
             text[i] = error_cmd[i];   // �������� ����� ���
                             }
           sim900 = 7;                 // ���������� ���
          }
     clean_rx_buff();                  // ������� ������ �����
                          }
       }
break;
case 7:{
        sms();                         // ��������� ���
       }
break;
case 8:{
         if (Timer[1].flag == 0) {
             clean();               // ������� ��� ������
                                 }
       }
break;
               }
                }

if ((status_SIM) && (iniflag == 0) && (sim900 != 7) && (alarm == 1)){ u8 i; // ����� ������ ��������
//SGPIO(read,pin_1,0,0); // �������
switch (pin) {
case check: {
   if (Timer[2].flag == 0) {
             once_open = 1;                 // ���.�������� ������
                           }
   if (Timer[3].flag == 0) {
             once_crash = 1;                // ���.�������� ����.�����
                           }
   if (PINB.2 && once_open) {pin = open;    // ����� �������
                once_open = 0;              // ����.��������
                for (i=0;i<11;i++){
                text[i] = open_door[i];     // �������� ����� ���
                                  }
                soft_delay(60000,2);        // delay 60s
                            }
   if (PINB.3 && once_crash) {pin = crash;  // ������ �����
                once_crash = 0;             // ����.��������
                for (i=0;i<11;i++){
                text[i] = crash_door[i];    // �������� ����� ���
                                  }
                soft_delay(60000,3);        // delay 60s
                             }
                    }
break;
case open: {
            sms();                          // ��������� ���
           }
break;
case crash: {
             sms();                         // ��������� ���
            }
break;
case cln: {
           if (Timer[1].flag == 0) {
           clean();     // ������� ��� ������
           pin = check; // �� ������ ���
                                   }
          }
break;
             }
                                                                    }

if ((!status_SIM) && (sim900 != 100) && (state)){ // ���������, ���� ��� ������� pwr
      iniflag = 1;
      sim900 = 0;
      clean_rx_buff();
      pwrkey_change(1,1200); // ���.������ �� 1200��
      state =0;
                                                }

if ((sim900 != 100) && (Timer[2].flag == 0) && (state ==0)){ // ��������� ������ ���������
     pwrkey_change(0,900);   // ����.������
     state = 1;
                                                           }

if (sim900 == 100) { // res_sim900(); ����� sim900
switch (push){
case 0:{
        key_repit(); // ����.������ sim900
       }
break;
case 1:{
        if (Timer[2].flag == 0) { // ��� 2���.
            push++;  // ������ ������� (���.)
                                }
       }
break;
case 2:{
        key_repit(); // ���.������ sim900
       }
break;
case 3:{
        sim900 = 0;
        ATflag = 1;
        iniflag = 1;
        push = 0;
       }
break;  
             }
                   }
         }
               }