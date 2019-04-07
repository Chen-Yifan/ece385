/*
 * Avalon memory-mapped peripheral for the VGA LED Emulator
 *
 * Stephen A. Edwards
 * Columbia University
 */

module VGA_LED(input logic        clk,
	       input logic 	          reset,
	       input logic [31:0]       writedata,			 
	       input logic 	          write,
	       input 		             chipselect,
	       input logic [1:0]       address,

	       output logic [7:0]      VGA_R, VGA_G, VGA_B,
	       output logic 	          VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	       output logic 	          VGA_SYNC_n,
	       output logic[3:0]       VGA_audio_control
			// output logic[3:0]       LED

	       //input logic             audio_ready
			 
			 
			 );
			 
			
		//logic [3:0]test;	
		//assign VGA_audio_control=test;
		logic write_enable;
		logic [4:0] item; 
		logic [7:0] map_address;
		//logic left,right,up,down,win,lose;
		//logic left1,right1,up1,down1,win1,lose1;
		logic [2:0] red_control;
		logic [2:0] blue_control;
		
		
		
		
		logic [3:0]audio_control;
		logic reset_control;
		//logic reset_signal;
		
		
		//assign VGA_audio_control = writedata[17:14];
		//assign VGA_audio_control[3] = reset_control;
		
		//assign VGA_audio_control[0]=reset_signal;
		
		//assign reset_signal=reset_control || reset;
		
		assign VGA_audio_control=audio_control;
		
		

		logic       interstateEnd;
		
//		
//	
      VGA_LED_Emulator led_emulator(.clk50(clk), .reset(reset_control), .*);

	
always_ff @(posedge clk)
 



  if (reset) begin
	
	  write_enable<=0;
	  red_control<=0;
	  blue_control<=0;
     item<=0;
	  map_address<=0;
	  interstateEnd<=0;
	 // audio_control<=0;
	  reset_control<=1;

   end else if (chipselect && write)  begin
	  
			
				
		
			//reset_control<=0;
			if (writedata[5] == 1) begin
			
					write_enable <= 1;
					map_address[7:0] <= writedata[13:6];
					item[4:0] <= writedata[4:0];
				//	audio_control<=writedata[13:6];
					reset_control<= 0;
			end else begin
		
					blue_control<=0;
					red_control<=0;
					//write_enable <= 0;
			
				
					if(writedata[3]==0) begin
						blue_control<=writedata[2:0];
						interstateEnd<=writedata[4];
					  
					  
					end else if(writedata[3]==1) begin 
				      red_control<=writedata[2:0];
					   interstateEnd<=writedata[4];
					  
					  
		         end 
		  
		   
		
	
					if((writedata[13]==1) && (writedata[12]==1) && (writedata[11]==1) && (writedata[10]==1) && (writedata[9]==1) && (writedata[8]==1) && (writedata[7]==1) && (writedata[6]==1)) begin
						reset_control<= 1;	
					end else 
						reset_control<= 0;
			end
	 
			
		  
		  
	 end else begin
			reset_control<=0;
			//VGA_audio_control[3] <= 0;
	 end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	always_ff @(posedge clk)

  if (reset) begin
	
	  audio_control<=0;
	  
   end else if (chipselect && write)  begin
	  
			
				
		
			//reset_control<=0;
			//if (writedata[5] == 1) begin
			
				
				if(writedata[13:6]==8'b11111000) begin
				   audio_control<=4'b0001;
				end else if(writedata[13:6]==8'b11111100) begin
				   audio_control<=4'b0010;
				end else if(writedata[13:6]==8'b11111110) begin
				   audio_control<=4'b0100;
				end else  begin
				   audio_control<=4'b0000;
				end
				
				
				
				
			//end else begin
		
				//	audio_control<=0;
	 end
	endmodule
