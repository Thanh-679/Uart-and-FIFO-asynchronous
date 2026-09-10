UART
////////////////////////////////////////////////////////////////////////////

<img width="1912" height="493" alt="image" src="https://github.com/user-attachments/assets/0e1f6fda-b0fe-4f0a-ade4-788f2fa66b8a" />
//check Transmitter


<img width="1886" height="582" alt="image" src="https://github.com/user-attachments/assets/2fd01dc4-a14a-41c0-897c-44fe51371333" />
//check receiver

<img width="1912" height="346" alt="image" src="https://github.com/user-attachments/assets/bd87a91c-e342-4526-9b16-06f041bea407" /> 
//check data_busy


<img width="1877" height="292" alt="image" src="https://github.com/user-attachments/assets/ee3fc6be-f3f1-47c7-a604-411a254e5cac" />
//check reset

<img width="1075" height="160" alt="image" src="https://github.com/user-attachments/assets/ce64d2d0-3e5f-4ee4-ba4e-77820120acf0" />
//register outside the module got the value


<img width="1090" height="92" alt="image" src="https://github.com/user-attachments/assets/f3592b86-03c4-4339-a4f1-25bc305d75db" />
//check end_of_frame

////////////////////////////////////////////////////////////////////////////////
<img width="1877" height="797" alt="image" src="https://github.com/user-attachments/assets/7778ca7d-55e8-49e8-bf93-395177425d6c" />
FIFO

/////////////////////////////////////////////////
<img width="1603" height="391" alt="image" src="https://github.com/user-attachments/assets/bf604821-ec59-402c-9f8e-db8a03214404" />
//for_example read

*Checking at CLK_write

-write_pointer_new calculates the next pointer, and w_gray_new is calculated in parallel.
-w_pointer and w_gray will wait for the next clock edge to update their values from w_pointer_new and w_gray_new.
(w_gray at CLK_write will be transferred to the CLK_read domain to be checked.)

*Checking at CLK_read
-No matter what value has changed, if the value was valid before CLK_read's edge occurred, it will remain valid at the moment CLK_read triggers.
(Since it is made of flip-flops, at CLK_write the value was checked and output, so CLK_read is simply seeing the output of CLK_write flip-flop
( — not a value freshly created at the moment after CLK_write done.))

-So, since the value is checked through the 2FF synchronizer, by the time CLK_read's posedge has occurred twice,
the comparison logic can immediately determine the new empty status. Therefore, at the next CLK_read edge (after synchronization completes), empty turns off.
///

<img width="1300" height="368" alt="image" src="https://github.com/user-attachments/assets/807de65f-6f0f-48d7-81e0-b83f086726f2" />
-Similarly: initially, the write side calculates pointer_new. Then, when waiting for the rising edge of CLK_write, the write side checks the request and data.
-If there is a request, the data is written to the address pointed to by the pointer that was calculated previously.
-After that, the combinational logic calculates write_pointer_new, then calculates w_gray_new and uses it to check full_new against r_pointer_2ff_gray,
so that full can be updated on the next CLK_write edge to determine whether the write pointer and w_gray should be updated and another write should be performed
-At the next rising edge of CLK_write, the data is written using the current (old) pointer, i.e. the pointer value before pointer_new becomes current.

///
<img width="1856" height="248" alt="image" src="https://github.com/user-attachments/assets/7129d2dc-7d28-43d7-9541-d613531aa9e7" />
//FIFO full and nearly full flag


//<img width="1407" height="261" alt="image" src="https://github.com/user-attachments/assets/9b4e6713-329e-4ec1-ab01-3191acac1d1d" />
//FIFO empty và nearly empty at the begining



<img width="1478" height="417" alt="image" src="https://github.com/user-attachments/assets/2075b9f7-9f13-4ff3-9eeb-584b3c4879c1" />
//FIFO empty and nearly empty


///////////////////////////////////////////////////////////////////////////////////////////
// AFTER CONNECTING FIFO TO UART


<img width="1882" height="147" alt="image" src="https://github.com/user-attachments/assets/3e2e2444-f120-4203-b54e-2bb02e6f5944" />
<img width="1867" height="506" alt="image" src="https://github.com/user-attachments/assets/d7d675eb-5d8f-477c-b260-7147677bbdf8" />




