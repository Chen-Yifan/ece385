/*
 * Seven-segment LED emulator
 *
 * Stephen A. Edwards, Columbia University
 */

module VGA_LED_Emulator(
 input logic 	    clk50, reset,
 input logic [2:0] red_control,
 input logic [2:0] blue_control,
 input logic  interstateEnd,
 input logic [4:0] item,
 input logic [7:0] map_address,
 input logic write_enable,
 
 output logic [7:0] VGA_R, VGA_G, VGA_B,
 output logic 	    VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n, VGA_SYNC_n


 );
 logic [7:0] a;
 logic [7:0] write_address;
 logic [4:0] din,dout;
 logic we;
 
memory m(.clk(clk50), .reset(reset), .a(a), .write_address(write_address), .din(din), .we(we), .dout(dout));

/*
 * 640 X 480 VGA timing for a 50 MHz clock: one pixel every other cycle
 * 
 * HCOUNT 1599 0             1279       1599 0
 *             _______________              ________
 * ___________|    Video      |____________|  Video
 * 
 * 
 * |SYNC| BP |<-- HACTIVE -->|FP|SYNC| BP |<-- HACTIVE
 *       _______________________      _____________
 * |____|       VGA_HS          |____|
 */
   // Parameters for hcount
   parameter HACTIVE      = 11'd 1280,
             HFRONT_PORCH = 11'd 32,
             HSYNC        = 11'd 192,
             HBACK_PORCH  = 11'd 96,   
             HTOTAL       = HACTIVE + HFRONT_PORCH + HSYNC + HBACK_PORCH; // 1600
   
   // Parameters for vcount
   parameter VACTIVE      = 10'd 480,
             VFRONT_PORCH = 10'd 10,
             VSYNC        = 10'd 2,
             VBACK_PORCH  = 10'd 33,
             VTOTAL       = VACTIVE + VFRONT_PORCH + VSYNC + VBACK_PORCH; // 525

   logic [10:0]			     hcount; // Horizontal counter
                                             // Hcount[10:1] indicates pixel column (0-639)
   logic 			     endOfLine;
   logic background;


   
   always_ff @(posedge clk50 or posedge reset)
     if (reset)          hcount <= 0;
     else if (endOfLine) hcount <= 0;
     else  	         hcount <= hcount + 11'd 1;

   assign endOfLine = hcount == HTOTAL - 1;

   // Vertical counter
   logic [9:0] 			     vcount;
   logic 			     endOfField;
   
   always_ff @(posedge clk50 or posedge reset)
     if (reset) begin      
		vcount <= 0;
		background <= 0;
     end else if (endOfLine)
       if (endOfField) begin
		vcount <= 0;
		if (background == 0) background <= 1;
       end
       else              vcount <= vcount + 10'd 1; 
		 
   assign endOfField = vcount == VTOTAL - 1;

   // Horizontal sync: from 0x520 to 0x5DF (0x57F)
   // 101 0010 0000 to 101 1101 1111
   assign VGA_HS = !( (hcount[10:8] == 3'b101) & !(hcount[7:5] == 3'b111));
   assign VGA_VS = !( vcount[9:1] == (VACTIVE + VFRONT_PORCH) / 2);

   assign VGA_SYNC_n = 1; // For adding sync to video signals; not used for VGA
   
   // Horizontal active: 0 to 1279     Vertical active: 0 to 479
   // 101 0000 0000  1280	       01 1110 0000  480
   // 110 0011 1111  1599	       10 0000 1100  524
   assign VGA_BLANK_n = !( hcount[10] & (hcount[9] | hcount[8]) ) &
			!( vcount[9] | (vcount[8:5] == 4'b1111) );   

   /* VGA_CLK is 25 MHz
    *             __    __    __
    * clk50    __|  |__|  |__|
    *        
    *             _____       __
    * hcount[0]__|     |_____|	
    */
   assign VGA_CLK = hcount[0]; // 25 MHz clock: pixel latched on rising edge
	
	logic [9:0] vcountmp;
	logic [10:0] hcountmp;
	logic [9:0] vcountmp1;
	logic [10:0] hcountmp1;
   logic [9:0] addressscreen;
	logic [9:0] addressscreen1;
	logic [9:0] addressscreen2;
	
	
   logic [14:0] dataBrick,dataGrasswithshadow,dataWall,databomb;
	logic [14:0] dataflame1,dataflame2,dataflame3,dataflame4,dataflame5,dataflame6,dataflame7;
        logic [14:0] g1,g2,g3,g4,g5,g6;
	
	logic [14:0] databluefront_1_top,databluefront_2_top,databluefront_1_bottom,databluefront_2_bottom;
	logic [14:0] datablueback_1_top,datablueback_2_top,datablueback_1_bottom,datablueback_2_bottom;
	logic [14:0] datablueleft_1_top,datablueleft_2_top,datablueleft_1_bottom,datablueleft_2_bottom;
	logic [14:0] datablueright_1_top,datablueright_2_top,datablueright_1_bottom,datablueright_2_bottom;
	logic [14:0] databluestand_1_top,databluesit_1_top,databluestand_1_bottom,databluesit_1_bottom;
	
	
	logic [14:0] dataredfront_1_top,dataredfront_2_top,dataredfront_1_bottom,dataredfront_2_bottom;
	logic [14:0] dataredback_1_top,dataredback_2_top,dataredback_1_bottom,dataredback_2_bottom;
	logic [14:0] dataredleft_1_top,dataredleft_2_top,dataredleft_1_bottom,dataredleft_2_bottom;
	logic [14:0] dataredright_1_top,dataredright_2_top,dataredright_1_bottom,dataredright_2_bottom;
	logic [14:0] dataredstand_1_top,dataredsit_1_top,dataredstand_1_bottom,dataredsit_1_bottom;
	
	
	logic [10:0] player1_hcount;
	logic [9:0] player1_vcount;
	
	logic [10:0] player2_hcount;
	logic [9:0] player2_vcount;
	
	
	
	logic [3:0] state;
	//logic [22:0] state_counter;
	
	logic [3:0] state1;
	//logic [22:0] state1_counter;
	
	logic [1:0] state_audio;
	
	
        brick Brick(.address(addressscreen),.clock(clk50),.q(dataBrick));
        grasswithshadow Grasswithshadow(.address(addressscreen),.clock(clk50),.q(dataGrasswithshadow));
	wall w(.address(addressscreen),.clock(clk50),.q(dataWall));
	bomb Bomb(.address(addressscreen),.clock(clk50),.q(databomb));
        grift1 G1(.address(addressscreen),.clock(clk50),.q(g1));
        grift2 G2(.address(addressscreen),.clock(clk50),.q(g2));
        grift3 G3(.address(addressscreen),.clock(clk50),.q(g3));
        grift4 G4(.address(addressscreen),.clock(clk50),.q(g4));
		  gift5 G5(.address(addressscreen),.clock(clk50),.q(g5));
		  gift6 G6(.address(addressscreen),.clock(clk50),.q(g6));
	
	flame_center flame1(.address(addressscreen),.clock(clk50),.q(dataflame1));
	flame_h flame2(.address(addressscreen),.clock(clk50),.q(dataflame2));
	flame_v flame3(.address(addressscreen),.clock(clk50),.q(dataflame3));
	flame_left flame4(.address(addressscreen),.clock(clk50),.q(dataflame4));
	flame_right flame5(.address(addressscreen),.clock(clk50),.q(dataflame5));
	flame_up flame6(.address(addressscreen),.clock(clk50),.q(dataflame6));
	flame_down flame7(.address(addressscreen),.clock(clk50),.q(dataflame7));
	
	bluefront_1_top bluefronttop1(.address(addressscreen1),.clock(clk50),.q(databluefront_1_top));
	bluefront_2_top bluefronttop2(.address(addressscreen1),.clock(clk50),.q(databluefront_2_top));
	bluefront_1_bottom bluefrontbottom1(.address(addressscreen1),.clock(clk50),.q(databluefront_1_bottom));
	bluefront_2_bottom bluefrontbottom2(.address(addressscreen1),.clock(clk50),.q(databluefront_2_bottom));
	blueback_1_top bluebacktop1(.address(addressscreen1),.clock(clk50),.q(datablueback_1_top));
	blueback_2_top bluebacktop2(.address(addressscreen1),.clock(clk50),.q(datablueback_2_top));
	blueback_1_bottom bluebackbottom1(.address(addressscreen1),.clock(clk50),.q(datablueback_1_bottom));
	blueback_2_bottom bluebackbottom2(.address(addressscreen1),.clock(clk50),.q(datablueback_2_bottom));
	blueleft_1_top bluelefttop1(.address(addressscreen1),.clock(clk50),.q(datablueleft_1_top));
	blueleft_2_top bluelefttop2(.address(addressscreen1),.clock(clk50),.q(datablueleft_2_top));
	blueleft_1_bottom blueleftbottom1(.address(addressscreen1),.clock(clk50),.q(datablueleft_1_bottom));
	blueleft_2_bottom blueleftbottom2(.address(addressscreen1),.clock(clk50),.q(datablueleft_2_bottom));
	blueright_1_top bluerighttop1(.address(addressscreen1),.clock(clk50),.q(datablueright_1_top));
	blueright_2_top bluerighttop2(.address(addressscreen1),.clock(clk50),.q(datablueright_2_top));
	blueright_1_bottom bluerightbottom1(.address(addressscreen1),.clock(clk50),.q(datablueright_1_bottom));
	blueright_2_bottom bluerightbottom2(.address(addressscreen1),.clock(clk50),.q(datablueright_2_bottom));
	
	bluestand_1_top bluestandtop1(.address(addressscreen1),.clock(clk50),.q(databluestand_1_top));
	bluestand_1_bottom bluestandbottom1(.address(addressscreen1),.clock(clk50),.q(databluestand_1_bottom));
	bluesit_1_top bluesittop1(.address(addressscreen1),.clock(clk50),.q(databluesit_1_top));
	bluesit_1_bottom bluesitbottom1(.address(addressscreen1),.clock(clk50),.q(databluesit_1_bottom));

	redfront_1_top redfronttop1(.address(addressscreen2),.clock(clk50),.q(dataredfront_1_top));
	redfront_2_top redfronttop2(.address(addressscreen2),.clock(clk50),.q(dataredfront_2_top));
	redfront_1_bottom redfrontbottom1(.address(addressscreen2),.clock(clk50),.q(dataredfront_1_bottom));
	redfront_2_bottom redfrontbottom2(.address(addressscreen2),.clock(clk50),.q(dataredfront_2_bottom));
	redback_1_top redbacktop1(.address(addressscreen2),.clock(clk50),.q(dataredback_1_top));
	redback_2_top redbacktop2(.address(addressscreen2),.clock(clk50),.q(dataredback_2_top));
	redback_1_bottom redbackbottom1(.address(addressscreen2),.clock(clk50),.q(dataredback_1_bottom));
	redback_2_bottom redbackbottom2(.address(addressscreen2),.clock(clk50),.q(dataredback_2_bottom));
	redleft_1_top redlefttop1(.address(addressscreen2),.clock(clk50),.q(dataredleft_1_top));
	redleft_2_top redlefttop2(.address(addressscreen2),.clock(clk50),.q(dataredleft_2_top));
	redleft_1_bottom redleftbottom1(.address(addressscreen2),.clock(clk50),.q(dataredleft_1_bottom));
	redleft_2_bottom redleftbottom2(.address(addressscreen2),.clock(clk50),.q(dataredleft_2_bottom));
	redright_1_top redrighttop1(.address(addressscreen2),.clock(clk50),.q(dataredright_1_top));
	redright_2_top redrighttop2(.address(addressscreen2),.clock(clk50),.q(dataredright_2_top));
	redright_1_bottom redrightbottom1(.address(addressscreen2),.clock(clk50),.q(dataredright_1_bottom));
	redright_2_bottom redrightbottom2(.address(addressscreen2),.clock(clk50),.q(dataredright_2_bottom));
	
	redstand_1_top redstandtop1(.address(addressscreen2),.clock(clk50),.q(dataredstand_1_top));
	redstand_1_bottom redstandbottom1(.address(addressscreen2),.clock(clk50),.q(dataredstand_1_bottom));
	redsit_1_top redsittop1(.address(addressscreen2),.clock(clk50),.q(dataredsit_1_top));
	redsit_1_bottom redsitbottom1(.address(addressscreen2),.clock(clk50),.q(dataredsit_1_bottom));


   always_ff @(posedge clk50 or posedge reset) begin
	   
      if (reset) begin
		addressscreen <= 0;
		addressscreen1 <= 0;
		addressscreen2 <= 0;
      end else if(hcount[0] == 0)     begin
			 addressscreen[9:0] <= hcount[5:1] + vcount[4:0] * 10'd 32 + 1;

			     hcountmp[10:1] <= hcount[10:1]-player1_hcount[10:1];
				  vcountmp[9:0] <= vcount[9:0]-player1_vcount[9:0];
				  addressscreen1[9:0] <= hcountmp[5:1] + vcountmp[4:0] * 10'd 32;
				  
				  hcountmp1[10:1] <= hcount[10:1]-player2_hcount[10:1];
				  vcountmp1[9:0] <= vcount[9:0]-player2_vcount[9:0];
				  addressscreen2[9:0] <= hcountmp1[5:1] + vcountmp1[4:0] * 10'd 32;
           
			 
   end
	end
	
	 always_ff @(posedge clk50 or posedge reset) begin
	   
      if (reset) begin		
			a <= 0;
      end 
		else if(hcount[0] == 0)     begin			
				if(hcount[5:1] ==31)
					a <= (hcount[10:6]-1 ) + (vcount[9:5] - 1 ) * 17 + 1 ; 
				else
					a <= (hcount[10:6]-1 ) + (vcount[9:5] - 1 ) * 17;	
		end
	end 

	always_ff @(posedge clk50 or posedge reset) begin
	   
      if (reset) begin		
			write_address <= 0;
      end else if(hcount[0] == 0)     begin		
					we <= 1;
					write_address <= map_address; 
					din <= item;
		end
	end
	

	// FSM for character 1
	
	always_ff @(posedge clk50 or posedge reset) begin
		if (reset) begin
			player1_hcount[10:1] <= 32;
			player1_hcount[0] <= 0;
			player1_vcount[9:0] <= 0;
			state <= 0;
		end else begin 
		

    	if (hcount[0] == 0) begin

			case(state)
				4'h0: begin
							if (blue_control == 1)	begin
									player1_hcount[10:1] <= player1_hcount[10:1] - 16;
							      state <= 1;
							end else if (blue_control  == 2) begin
									player1_hcount[10:1] <= player1_hcount[10:1] + 16;
									state <= 2;
							end else if (blue_control  == 3) begin
									player1_vcount[9:0] <= player1_vcount[9:0] - 16;
									state <= 4;
							end else if (blue_control  == 4) begin
									player1_vcount[9:0] <= player1_vcount[9:0] + 16;
									state <= 3;
							end else if (blue_control  == 5) begin
									state <= 8;
							end else if (blue_control  == 6) begin
									state <= 9;
							end
						end
				4'h1: begin
							if(interstateEnd==1) begin
								player1_hcount[10:1] <= player1_hcount[10:1] - 16;
								state <= 5;
							end
						end	
					
				
			   4'h2: begin
							
							if(interstateEnd==1) begin
								state <= 6;
								player1_hcount[10:1] <= player1_hcount[10:1] + 16;
							end
						end	
					
				
			   4'h3: begin
							if(interstateEnd==1) begin
								state <= 0;
								player1_vcount[9:0] <= player1_vcount[9:0] + 16;
							end
						end	
					
				4'h4: begin

							if(interstateEnd==1) begin
								state <= 7;
								player1_vcount[9:0] <= player1_vcount[9:0] - 16;
							end
						end		
							
				4'h5: begin

							if (blue_control  == 1)	begin
									player1_hcount[10:1] <= player1_hcount[10:1] - 16;
							      state <= 1;
							end else if (blue_control  == 2) begin
									player1_hcount[10:1] <= player1_hcount[10:1] + 16;
									state <= 2;
							end else if (blue_control  == 3) begin
									player1_vcount[9:0] <= player1_vcount[9:0] - 16;
									state <= 4;
							end else if (blue_control  == 4) begin
									player1_vcount[9:0] <= player1_vcount[9:0] + 16;
									state <= 3;
							end else if (blue_control  == 5) begin
									state <= 8;
							end else if (blue_control  == 6) begin
									state <= 9;
							end
						end
				4'h6: begin
							if (blue_control  == 1)	begin
									player1_hcount[10:1] <= player1_hcount[10:1] - 16;
							      state <= 1;
							end else if (blue_control  == 2) begin
									player1_hcount[10:1] <= player1_hcount[10:1] + 16;
									state <= 2;
							end else if (blue_control  == 3) begin
									player1_vcount[9:0] <= player1_vcount[9:0] - 16;
									state <= 4;
							end else if (blue_control  == 4) begin
									player1_vcount[9:0] <= player1_vcount[9:0] + 16;
									state <= 3;
							end else if (blue_control  == 5) begin
									state <= 8;
							end else if (blue_control  == 6) begin
									state <= 9;
							end
						end
						
				
				4'h7: begin
							if (blue_control  == 1)	begin
									player1_hcount[10:1] <= player1_hcount[10:1] - 16;
							      state <= 1;
							end else if (blue_control  == 2) begin
									player1_hcount[10:1] <= player1_hcount[10:1] + 16;
									state <= 2;
							end else if (blue_control  == 3) begin
									player1_vcount[9:0] <= player1_vcount[9:0] - 16;
									state <= 4;
							end else if (blue_control  == 4) begin
									player1_vcount[9:0] <= player1_vcount[9:0] + 16;
									state <= 3;
							end else if (blue_control  == 5) begin

									state <= 8;
							end else if (blue_control  == 6) begin
									state <= 9;
							end
						end
			     4'h8: ;
						
					
						
				  4'h9: ;
							
			endcase
		
		 end

		end
	end
	
	
	// FSM for character 2
	
		always_ff @(posedge clk50 or posedge reset) begin
		if (reset) begin
			player2_hcount[10:1] <= 544;
			player2_hcount[0] <= 0;
			player2_vcount[9:0] <= 384;
			state1 <= 0;
		end else begin 
		
		  if (hcount[0] == 0) begin

			case(state1)
				4'h0: begin
							if (red_control  == 1)	begin
									player2_hcount[10:1] <= player2_hcount[10:1] - 16;
							      state1 <= 1;
							end else if (red_control == 2) begin
									player2_hcount[10:1] <= player2_hcount[10:1] + 16;
									state1 <= 2;
							end else if (red_control == 3) begin
									player2_vcount[9:0] <= player2_vcount[9:0] - 16;
									state1 <= 4;
							end else if (red_control == 4) begin
									player2_vcount[9:0] <= player2_vcount[9:0] + 16;
									state1 <= 3;
							end else if (red_control == 5) begin
									state1 <= 8;
							end else if (red_control == 6) begin
									state1 <= 9;
							end
						end
				4'h1: begin
							
							if(interstateEnd==1) begin
								player2_hcount[10:1] <= player2_hcount[10:1] - 16;
								state1 <= 5;
							end
						end	
					
				
			   4'h2: begin
							
							if(interstateEnd==1) begin
								state1 <= 6;
								player2_hcount[10:1] <= player2_hcount[10:1] + 16;
							end
						end	
					
				
			   4'h3: begin

							if(interstateEnd==1) begin
								state1 <= 0;
								player2_vcount[9:0] <= player2_vcount[9:0] + 16;
							end
						end	
					
				4'h4: begin

							if(interstateEnd==1) begin
								state1 <= 7;
								player2_vcount[9:0] <= player2_vcount[9:0] - 16;
							end
						end		
							
				4'h5: begin
							if (red_control == 1)	begin
									player2_hcount[10:1] <= player2_hcount[10:1] - 16;
							      state1 <= 1;
							end else if (red_control == 2) begin
									player2_hcount[10:1] <= player2_hcount[10:1] + 16;
									state1 <= 2;
							end else if (red_control == 3) begin
									player2_vcount[9:0] <= player2_vcount[9:0] - 16;
									state1 <= 4;
							end else if (red_control == 4) begin
									player2_vcount[9:0] <= player2_vcount[9:0] + 16;
									state1 <= 3;
							end else if (red_control == 5) begin
									state1 <= 8;
							end else if (red_control == 6) begin
									state1 <= 9;
							end
						end
				4'h6: begin
							if (red_control == 1)	begin
									player2_hcount[10:1] <= player2_hcount[10:1] - 16;
							      state1 <= 1;
							end else if (red_control == 2) begin
									player2_hcount[10:1] <= player2_hcount[10:1] + 16;
									state1 <= 2;
							end else if (red_control == 3) begin
									player2_vcount[9:0] <= player2_vcount[9:0] - 16;
									state1 <= 4;
							end else if (red_control == 4) begin
									player2_vcount[9:0] <= player2_vcount[9:0] + 16;
									state1 <= 3;
							end else if (red_control == 5) begin
									state1 <= 8;
							end else if (red_control == 6) begin
									state1 <= 9;
							end
						end
						
				
				4'h7: begin
							if (red_control == 1)	begin
									player2_hcount[10:1] <= player2_hcount[10:1] - 16;
							      state1 <= 1;
							end else if (red_control == 2) begin
									player2_hcount[10:1] <= player2_hcount[10:1] + 16;
									state1 <= 2;
							end else if (red_control == 3) begin
									player2_vcount[9:0] <= player2_vcount[9:0] - 16;
									state1 <= 4;
							end else if (red_control == 4) begin
									player2_vcount[9:0] <= player2_vcount[9:0] + 16;
									state1 <= 3;
							end else if (red_control == 5) begin
									state1 <= 8;
							end else if (red_control == 6) begin
									state1 <= 9;
							end
						end
					 4'h8:;
					 4'h9:;
			
			endcase
		end
		
		end
	
end


 	  always_comb begin
	      if (hcount[10:1]>607)
		   {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h0}; // Black
			else
			 {VGA_R, VGA_G, VGA_B} = {8'h10, 8'h78, 8'h30}; // grass
			

		if(hcount[0] == 0) begin 
		   	
				
				
		// background layer		
		if (((vcount[9:0] < 32) | (vcount[9:0] >= 448)) & hcount[10:1] < 608)
			{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataBrick[14:10], dataBrick[9:5], dataBrick[4:0]}; 
			
		else if (((vcount[5] == 1) & (hcount[10:1] < 32 | (hcount[10:1] >= 576))) & hcount[10:1] < 608)
			{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataBrick[14:10], dataBrick[9:5], dataBrick[4:0]};
			
		else if ((vcount[5] == 0) & (hcount[6] == 0))
			{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataBrick[14:10], dataBrick[9:5], dataBrick[4:0]};
			
		else if ((vcount[9:0] < 64) & (vcount[9:0] >= 32) & (hcount[10:1] >= 32) & (hcount[10:1] < 576))
			{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataGrasswithshadow[14:10], dataGrasswithshadow[9:5], dataGrasswithshadow[4:0]};
			
		else if ((vcount[5] == 1) & (hcount[6] == 0) & (hcount[10:1] >= 32) & (hcount[10:1] < 576))
			{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataGrasswithshadow[14:10], dataGrasswithshadow[9:5], dataGrasswithshadow[4:0]};
			
     // memory map layer
		if (hcount[10:1] >= 32 & hcount[10:1] < 576 & vcount[9:0] >= 32 & vcount[9:0] < 448) begin	
			if (dout == 1)		
				{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataWall[14:10], dataWall[9:5], dataWall[4:0]};
			else if (dout == 2  && databomb!=15'b111110000011111)		
				{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databomb[14:10], databomb[9:5], databomb[4:0]};
				
		   else if(dout==25 && dataflame1!=0)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataflame1[14:10], dataflame1[9:5], dataflame1[4:0]};
				 
		   else if(dout==26 && dataflame2!=0)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataflame2[14:10], dataflame2[9:5], dataflame2[4:0]};
				 
				 
			else if(dout==27 && dataflame3!=0)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataflame3[14:10], dataflame3[9:5], dataflame3[4:0]};
				 
			else if(dout==28 && dataflame4!=0)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataflame4[14:10], dataflame4[9:5], dataflame4[4:0]};
				 
		   else if(dout==29 && dataflame5!=0)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataflame5[14:10], dataflame5[9:5], dataflame5[4:0]};
				 
			 else if(dout==30 && dataflame6!=0)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataflame6[14:10], dataflame6[9:5], dataflame6[4:0]};
				 
			 else if(dout==31 && dataflame7!=0)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataflame7[14:10], dataflame7[9:5], dataflame7[4:0]};
            
			 else if(dout==11 && g1!=15'b111110000011111)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {g1[14:10], g1[9:5], g1[4:0]};
				 
          else if(dout==12 && g2!=15'b111110000011111)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {g2[14:10], g2[9:5], g2[4:0]};
				 
          else if(dout==14 && g3!=15'b111110000011111)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {g3[14:10], g3[9:5], g3[4:0]};
				 
          else if(dout==13 && g4!=15'b111110000011111)
			    {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {g4[14:10], g4[9:5], g4[4:0]};
				
		    else if(dout==15 && g5!=15'b111110000011111)
				 {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {g5[14:10], g5[9:5], g5[4:0]};
				 
			 else if(dout==16 && g6!=15'b111110000011111)
				 {VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {g6[14:10], g6[9:5], g6[4:0]};
		end

	// character layer	
   if(player1_vcount[9:0]<player2_vcount[9:0])  begin	
	
		if (player1_hcount[10:1] < (hcount[10:1] -1) & player1_hcount[10:1] + 32 > (hcount[10:1]-1)  & player1_vcount[9:0] + 32 > vcount[9:0] & (player1_vcount[9:0] < vcount[9:0] || player1_vcount[9:0] == vcount[9:0])) begin
			case(state)
				4'h3 : begin
						if((databluefront_2_top[14:10] !=  0) | (databluefront_2_top[9:5] != 0) | (databluefront_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_2_top[14:10], databluefront_2_top[9:5], databluefront_2_top[4:0]};
						end
				4'h0 : begin
						if((databluefront_1_top[14:10] !=  0) | (databluefront_1_top[9:5] != 0) | (databluefront_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_1_top[14:10], databluefront_1_top[9:5], databluefront_1_top[4:0]};
						end
				4'h4 : begin
						if((datablueback_2_top[14:10] !=  0) | (datablueback_2_top[9:5] != 0) | (datablueback_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueback_2_top[14:10], datablueback_2_top[9:5], datablueback_2_top[4:0]};
						end
				4'h7 : begin
						if((datablueback_1_top[14:10] !=  0) | (datablueback_1_top[9:5] != 0) | (datablueback_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueback_1_top[14:10], datablueback_1_top[9:5], datablueback_1_top[4:0]};
						end
				4'h2 : begin
						if((datablueright_2_top[14:10] !=  0) | (datablueright_2_top[9:5] != 0) | (datablueright_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_2_top[14:10], datablueright_2_top[9:5], datablueright_2_top[4:0]};
						end
				4'h6 : begin
						if((datablueright_1_top[14:10] !=  0) | (datablueright_1_top[9:5] != 0) | (datablueright_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_1_top[14:10], datablueright_1_top[9:5], datablueright_1_top[4:0]};
						end
				4'h1 : begin
						if((datablueleft_2_top[14:10] !=  0) | (datablueleft_2_top[9:5] != 0) | (datablueleft_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_2_top[14:10], datablueleft_2_top[9:5], datablueleft_2_top[4:0]};
						end
				4'h5 : begin
						if((datablueleft_1_top[14:10] !=  0) | (datablueleft_1_top[9:5] != 0) | (datablueleft_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_1_top[14:10], datablueleft_1_top[9:5], datablueleft_1_top[4:0]};
						end
				4'h8 : begin
						if((databluestand_1_top[14:10] !=  0) | (databluestand_1_top[9:5] != 0) | (databluestand_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluestand_1_top[14:10], databluestand_1_top[9:5], databluestand_1_top[4:0]};
						end
				4'h9 : begin
						if((databluesit_1_top[14:10] !=  0) | (databluesit_1_top[9:5] != 0) | (databluesit_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluesit_1_top[14:10], databluesit_1_top[9:5], databluesit_1_top[4:0]};
						end
				
			endcase
			
		end else if (player1_hcount[10:1] < (hcount[10:1]-1) & player1_hcount[10:1] + 32 >= (hcount[10:1]-1)  & (player1_vcount[9:0] + 32 < vcount[9:0] || player1_vcount[9:0] + 32 == vcount[9:0]) & player1_vcount[9:0] + 64 > vcount[9:0]) begin
			case(state)
				4'h3 : begin
						if((databluefront_2_bottom[14:10] !=  0) | (databluefront_2_bottom[9:5] != 0) | (databluefront_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_2_bottom[14:10], databluefront_2_bottom[9:5], databluefront_2_bottom[4:0]};
						end
				4'h0 : begin
						if((databluefront_1_bottom[14:10] !=  0) | (databluefront_1_bottom[9:5] != 0) | (databluefront_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_1_bottom[14:10], databluefront_1_bottom[9:5], databluefront_1_bottom[4:0]};
						end
				4'h4 : begin
						if((datablueback_2_bottom[14:10] !=  0) | (datablueback_2_bottom[9:5] != 0) | (datablueback_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {datablueback_2_bottom[14:10], datablueback_2_bottom[9:5], datablueback_2_bottom[4:0]};
						end
				4'h7 : begin
						if((datablueback_1_bottom[14:10] !=  0) | (datablueback_1_bottom[9:5] != 0) | (datablueback_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueback_1_bottom[14:10], datablueback_1_bottom[9:5], datablueback_1_bottom[4:0]};
						end
				4'h2 : begin
						if((datablueright_2_bottom[14:10] !=  0) | (datablueright_2_bottom[9:5] != 0) | (datablueright_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_2_bottom[14:10], datablueright_2_bottom[9:5], datablueright_2_bottom[4:0]};
						end
				4'h6 : begin
						if((datablueright_1_bottom[14:10] !=  0) | (datablueright_1_bottom[9:5] != 0) | (datablueright_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_1_bottom[14:10], datablueright_1_bottom[9:5], datablueright_1_bottom[4:0]};
						end
				4'h1 : begin
						if((datablueleft_2_bottom[14:10] !=  0) | (datablueleft_2_bottom[9:5] != 0) | (datablueleft_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_2_bottom[14:10], datablueleft_2_bottom[9:5], datablueleft_2_bottom[4:0]};
						end
				4'h5 : begin
						if((datablueleft_1_bottom[14:10] !=  0) | (datablueleft_1_bottom[9:5] != 0) | (datablueleft_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_1_bottom[14:10], datablueleft_1_bottom[9:5], datablueleft_1_bottom[4:0]};
						end
				4'h8 : begin
						if((databluestand_1_bottom[14:10] !=  0) | (databluestand_1_bottom[9:5] != 0) | (databluestand_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluestand_1_bottom[14:10], databluestand_1_bottom[9:5], databluestand_1_bottom[4:0]};
						end
				4'h9 : begin
						if((databluesit_1_bottom[14:10] !=  0) | (databluesit_1_bottom[9:5] != 0) | (databluesit_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluesit_1_bottom[14:10], databluesit_1_bottom[9:5], databluesit_1_bottom[4:0]};
						end
				
			endcase
			end
			
			
			
			
			
		if (player2_hcount[10:1] < (hcount[10:1] -1) & player2_hcount[10:1] + 32 > (hcount[10:1]-1)  & player2_vcount[9:0] + 32 > vcount[9:0] & (player2_vcount[9:0] < vcount[9:0] || player2_vcount[9:0] == vcount[9:0])) begin
			case(state1)
				4'h3 : begin
						if((dataredfront_2_top[14:10] !=  0) | (dataredfront_2_top[9:5] != 0) | (dataredfront_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_2_top[14:10], dataredfront_2_top[9:5], dataredfront_2_top[4:0]};
						end
				4'h0 : begin
						if((dataredfront_1_top[14:10] !=  0) | (dataredfront_1_top[9:5] != 0) | (dataredfront_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_1_top[14:10], dataredfront_1_top[9:5], dataredfront_1_top[4:0]};
						end
				4'h4 : begin
						if((dataredback_2_top[14:10] !=  0) | (dataredback_2_top[9:5] != 0) | (dataredback_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredback_2_top[14:10], dataredback_2_top[9:5], dataredback_2_top[4:0]};
						end
				4'h7 : begin
						if((dataredback_1_top[14:10] !=  0) | (dataredback_1_top[9:5] != 0) | (dataredback_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredback_1_top[14:10], dataredback_1_top[9:5], dataredback_1_top[4:0]};
						end
				4'h2 : begin
						if((dataredright_2_top[14:10] !=  0) | (dataredright_2_top[9:5] != 0) | (dataredright_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredright_2_top[14:10], dataredright_2_top[9:5], dataredright_2_top[4:0]};
						end
				4'h6 : begin
						if((dataredright_1_top[14:10] !=  0) | (dataredright_1_top[9:5] != 0) | (dataredright_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredright_1_top[14:10], dataredright_1_top[9:5], dataredright_1_top[4:0]};
						end
				4'h1 : begin
						if((dataredleft_2_top[14:10] !=  0) | (dataredleft_2_top[9:5] != 0) | (dataredleft_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredleft_2_top[14:10], dataredleft_2_top[9:5], dataredleft_2_top[4:0]};
						end
				4'h5 : begin
						if((dataredleft_1_top[14:10] !=  0) | (dataredleft_1_top[9:5] != 0) | (dataredleft_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredleft_1_top[14:10], dataredleft_1_top[9:5], dataredleft_1_top[4:0]};
						end
				4'h8 : begin
						if((dataredstand_1_top[14:10] !=  0) | (dataredstand_1_top[9:5] != 0) | (dataredstand_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredstand_1_top[14:10], dataredstand_1_top[9:5], dataredstand_1_top[4:0]};
						end
				4'h9 : begin
						if((dataredsit_1_top[14:10] !=  0) | (dataredsit_1_top[9:5] != 0) | (dataredsit_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredsit_1_top[14:10], dataredsit_1_top[9:5], dataredsit_1_top[4:0]};
						end
				
			endcase
			
		end else if (player2_hcount[10:1] < (hcount[10:1]-1) & player2_hcount[10:1] + 32 >= (hcount[10:1]-1)  & (player2_vcount[9:0] + 32 < vcount[9:0] || player2_vcount[9:0] + 32 == vcount[9:0]) & player2_vcount[9:0] + 64 > vcount[9:0]) begin
			case(state1)
				4'h3 : begin
						if((dataredfront_2_bottom[14:10] !=  0) | (dataredfront_2_bottom[9:5] != 0) | (dataredfront_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_2_bottom[14:10], dataredfront_2_bottom[9:5], dataredfront_2_bottom[4:0]};
						end
				4'h0 : begin
						if((dataredfront_1_bottom[14:10] !=  0) | (dataredfront_1_bottom[9:5] != 0) | (dataredfront_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_1_bottom[14:10], dataredfront_1_bottom[9:5], dataredfront_1_bottom[4:0]};
						end
				4'h4 : begin
						if((dataredback_2_bottom[14:10] !=  0) | (dataredback_2_bottom[9:5] != 0) | (dataredback_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredback_2_bottom[14:10], dataredback_2_bottom[9:5], dataredback_2_bottom[4:0]};
						end
				4'h7 : begin
						if((dataredback_1_bottom[14:10] !=  0) | (dataredback_1_bottom[9:5] != 0) | (dataredback_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredback_1_bottom[14:10], dataredback_1_bottom[9:5], dataredback_1_bottom[4:0]};
						end
				4'h2 : begin
						if((dataredright_2_bottom[14:10] !=  0) | (dataredright_2_bottom[9:5] != 0) | (dataredright_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredright_2_bottom[14:10], dataredright_2_bottom[9:5], dataredright_2_bottom[4:0]};
						end
				4'h6 : begin
						if((dataredright_1_bottom[14:10] !=  0) | (dataredright_1_bottom[9:5] != 0) | (dataredright_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredright_1_bottom[14:10], dataredright_1_bottom[9:5], dataredright_1_bottom[4:0]};
						end
				4'h1 : begin
						if((dataredleft_2_bottom[14:10] !=  0) | (dataredleft_2_bottom[9:5] != 0) | (dataredleft_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredleft_2_bottom[14:10], dataredleft_2_bottom[9:5], dataredleft_2_bottom[4:0]};
						end
				4'h5 : begin
						if((dataredleft_1_bottom[14:10] !=  0) | (dataredleft_1_bottom[9:5] != 0) | (dataredleft_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredleft_1_bottom[14:10], dataredleft_1_bottom[9:5], dataredleft_1_bottom[4:0]};
						end
				4'h8 : begin
						if((dataredstand_1_bottom[14:10] !=  0) | (dataredstand_1_bottom[9:5] != 0) | (dataredstand_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredstand_1_bottom[14:10], dataredstand_1_bottom[9:5], dataredstand_1_bottom[4:0]};
						end
				4'h9 : begin
						if((dataredsit_1_bottom[14:10] !=  0) | (dataredsit_1_bottom[9:5] != 0) | (dataredsit_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredsit_1_bottom[14:10], dataredsit_1_bottom[9:5], dataredsit_1_bottom[4:0]};
						end
				
			endcase		
	 end

   end else begin
	
		
		if (player2_hcount[10:1] < (hcount[10:1] -1) & player2_hcount[10:1] + 32 > (hcount[10:1]-1)  & player2_vcount[9:0] + 32 > vcount[9:0] & (player2_vcount[9:0] < vcount[9:0] || player2_vcount[9:0] == vcount[9:0])) begin
			case(state1)
				4'h3 : begin
						if((dataredfront_2_top[14:10] !=  0) | (dataredfront_2_top[9:5] != 0) | (dataredfront_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_2_top[14:10], dataredfront_2_top[9:5], dataredfront_2_top[4:0]};
						end
				4'h0 : begin
						if((dataredfront_1_top[14:10] !=  0) | (dataredfront_1_top[9:5] != 0) | (dataredfront_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_1_top[14:10], dataredfront_1_top[9:5], dataredfront_1_top[4:0]};
						end
				4'h4 : begin
						if((dataredback_2_top[14:10] !=  0) | (dataredback_2_top[9:5] != 0) | (dataredback_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredback_2_top[14:10], dataredback_2_top[9:5], dataredback_2_top[4:0]};
						end
				4'h7 : begin
						if((dataredback_1_top[14:10] !=  0) | (dataredback_1_top[9:5] != 0) | (dataredback_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredback_1_top[14:10], dataredback_1_top[9:5], dataredback_1_top[4:0]};
						end
				4'h2 : begin
						if((dataredright_2_top[14:10] !=  0) | (dataredright_2_top[9:5] != 0) | (dataredright_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredright_2_top[14:10], dataredright_2_top[9:5], dataredright_2_top[4:0]};
						end
				4'h6 : begin
						if((dataredright_1_top[14:10] !=  0) | (dataredright_1_top[9:5] != 0) | (dataredright_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredright_1_top[14:10], dataredright_1_top[9:5], dataredright_1_top[4:0]};
						end
				4'h1 : begin
						if((dataredleft_2_top[14:10] !=  0) | (dataredleft_2_top[9:5] != 0) | (dataredleft_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredleft_2_top[14:10], dataredleft_2_top[9:5], dataredleft_2_top[4:0]};
						end
				4'h5 : begin
						if((dataredleft_1_top[14:10] !=  0) | (dataredleft_1_top[9:5] != 0) | (dataredleft_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredleft_1_top[14:10], dataredleft_1_top[9:5], dataredleft_1_top[4:0]};
						end
				4'h8 : begin
						if((dataredstand_1_top[14:10] !=  0) | (dataredstand_1_top[9:5] != 0) | (dataredstand_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredstand_1_top[14:10], dataredstand_1_top[9:5], dataredstand_1_top[4:0]};
						end
				4'h9 : begin
						if((dataredsit_1_top[14:10] !=  0) | (dataredsit_1_top[9:5] != 0) | (dataredsit_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {dataredsit_1_top[14:10], dataredsit_1_top[9:5], dataredsit_1_top[4:0]};
						end		
			endcase
			
		end else if (player2_hcount[10:1] < (hcount[10:1]-1) & player2_hcount[10:1] + 32 >= (hcount[10:1]-1)  & (player2_vcount[9:0] + 32 < vcount[9:0] || player2_vcount[9:0] + 32 == vcount[9:0]) & player2_vcount[9:0] + 64 > vcount[9:0]) begin
			case(state1)
				4'h3 : begin
						if((dataredfront_2_bottom[14:10] !=  0) | (dataredfront_2_bottom[9:5] != 0) | (dataredfront_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_2_bottom[14:10], dataredfront_2_bottom[9:5], dataredfront_2_bottom[4:0]};
						end
				4'h0 : begin
						if((dataredfront_1_bottom[14:10] !=  0) | (dataredfront_1_bottom[9:5] != 0) | (dataredfront_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredfront_1_bottom[14:10], dataredfront_1_bottom[9:5], dataredfront_1_bottom[4:0]};
						end
				4'h4 : begin
						if((dataredback_2_bottom[14:10] !=  0) | (dataredback_2_bottom[9:5] != 0) | (dataredback_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredback_2_bottom[14:10], dataredback_2_bottom[9:5], dataredback_2_bottom[4:0]};
						end
				4'h7 : begin
						if((dataredback_1_bottom[14:10] !=  0) | (dataredback_1_bottom[9:5] != 0) | (dataredback_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredback_1_bottom[14:10], dataredback_1_bottom[9:5], dataredback_1_bottom[4:0]};
						end
				4'h2 : begin
						if((dataredright_2_bottom[14:10] !=  0) | (dataredright_2_bottom[9:5] != 0) | (dataredright_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredright_2_bottom[14:10], dataredright_2_bottom[9:5], dataredright_2_bottom[4:0]};
						end
				4'h6 : begin
						if((dataredright_1_bottom[14:10] !=  0) | (dataredright_1_bottom[9:5] != 0) | (dataredright_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredright_1_bottom[14:10], dataredright_1_bottom[9:5], dataredright_1_bottom[4:0]};
						end
				4'h1 : begin
						if((dataredleft_2_bottom[14:10] !=  0) | (dataredleft_2_bottom[9:5] != 0) | (dataredleft_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredleft_2_bottom[14:10], dataredleft_2_bottom[9:5], dataredleft_2_bottom[4:0]};
						end
				4'h5 : begin
						if((dataredleft_1_bottom[14:10] !=  0) | (dataredleft_1_bottom[9:5] != 0) | (dataredleft_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredleft_1_bottom[14:10], dataredleft_1_bottom[9:5], dataredleft_1_bottom[4:0]};
						end
				4'h8 : begin
						if((dataredstand_1_bottom[14:10] !=  0) | (dataredstand_1_bottom[9:5] != 0) | (dataredstand_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredstand_1_bottom[14:10], dataredstand_1_bottom[9:5], dataredstand_1_bottom[4:0]};
						end
				4'h9 : begin
						if((dataredsit_1_bottom[14:10] !=  0) | (dataredsit_1_bottom[9:5] != 0) | (dataredsit_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {dataredsit_1_bottom[14:10], dataredsit_1_bottom[9:5], dataredsit_1_bottom[4:0]};
						end
				
			endcase		
	 end
	 
	 if (player1_hcount[10:1] < (hcount[10:1] -1) & player1_hcount[10:1] + 32 > (hcount[10:1]-1)  & player1_vcount[9:0] + 32 > vcount[9:0] & (player1_vcount[9:0] < vcount[9:0] || player1_vcount[9:0] == vcount[9:0])) begin
			case(state)
				4'h3 : begin
						if((databluefront_2_top[14:10] !=  0) | (databluefront_2_top[9:5] != 0) | (databluefront_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_2_top[14:10], databluefront_2_top[9:5], databluefront_2_top[4:0]};
						end
				4'h0 : begin
						if((databluefront_1_top[14:10] !=  0) | (databluefront_1_top[9:5] != 0) | (databluefront_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_1_top[14:10], databluefront_1_top[9:5], databluefront_1_top[4:0]};
						end
				4'h4 : begin
						if((datablueback_2_top[14:10] !=  0) | (datablueback_2_top[9:5] != 0) | (datablueback_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueback_2_top[14:10], datablueback_2_top[9:5], datablueback_2_top[4:0]};
						end
				4'h7 : begin
						if((datablueback_1_top[14:10] !=  0) | (datablueback_1_top[9:5] != 0) | (datablueback_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueback_1_top[14:10], datablueback_1_top[9:5], datablueback_1_top[4:0]};
						end
				4'h2 : begin
						if((datablueright_2_top[14:10] !=  0) | (datablueright_2_top[9:5] != 0) | (datablueright_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_2_top[14:10], datablueright_2_top[9:5], datablueright_2_top[4:0]};
						end
				4'h6 : begin
						if((datablueright_1_top[14:10] !=  0) | (datablueright_1_top[9:5] != 0) | (datablueright_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_1_top[14:10], datablueright_1_top[9:5], datablueright_1_top[4:0]};
						end
				4'h1 : begin
						if((datablueleft_2_top[14:10] !=  0) | (datablueleft_2_top[9:5] != 0) | (datablueleft_2_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_2_top[14:10], datablueleft_2_top[9:5], datablueleft_2_top[4:0]};
						end
				4'h5 : begin
						if((datablueleft_1_top[14:10] !=  0) | (datablueleft_1_top[9:5] != 0) | (datablueleft_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_1_top[14:10], datablueleft_1_top[9:5], datablueleft_1_top[4:0]};
						end
				4'h8 : begin
						if((databluestand_1_top[14:10] !=  0) | (databluestand_1_top[9:5] != 0) | (databluestand_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluestand_1_top[14:10], databluestand_1_top[9:5], databluestand_1_top[4:0]};
						end
				4'h9 : begin
						if((databluesit_1_top[14:10] !=  0) | (databluesit_1_top[9:5] != 0) | (databluesit_1_top[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluesit_1_top[14:10], databluesit_1_top[9:5], databluesit_1_top[4:0]};
						end
				
			endcase
			
		end else if (player1_hcount[10:1] < (hcount[10:1]-1) & player1_hcount[10:1] + 32 >= (hcount[10:1]-1)  & (player1_vcount[9:0] + 32 < vcount[9:0] || player1_vcount[9:0] + 32 == vcount[9:0]) & player1_vcount[9:0] + 64 > vcount[9:0]) begin
			case(state)
				4'h3 : begin
						if((databluefront_2_bottom[14:10] !=  0) | (databluefront_2_bottom[9:5] != 0) | (databluefront_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_2_bottom[14:10], databluefront_2_bottom[9:5], databluefront_2_bottom[4:0]};
						end
				4'h0 : begin
						if((databluefront_1_bottom[14:10] !=  0) | (databluefront_1_bottom[9:5] != 0) | (databluefront_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluefront_1_bottom[14:10], databluefront_1_bottom[9:5], databluefront_1_bottom[4:0]};
						end
				4'h4 : begin
						if((datablueback_2_bottom[14:10] !=  0) | (datablueback_2_bottom[9:5] != 0) | (datablueback_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]}= {datablueback_2_bottom[14:10], datablueback_2_bottom[9:5], datablueback_2_bottom[4:0]};
						end
				4'h7 : begin
						if((datablueback_1_bottom[14:10] !=  0) | (datablueback_1_bottom[9:5] != 0) | (datablueback_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueback_1_bottom[14:10], datablueback_1_bottom[9:5], datablueback_1_bottom[4:0]};
						end
				4'h2 : begin
						if((datablueright_2_bottom[14:10] !=  0) | (datablueright_2_bottom[9:5] != 0) | (datablueright_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_2_bottom[14:10], datablueright_2_bottom[9:5], datablueright_2_bottom[4:0]};
						end
				4'h6 : begin
						if((datablueright_1_bottom[14:10] !=  0) | (datablueright_1_bottom[9:5] != 0) | (datablueright_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueright_1_bottom[14:10], datablueright_1_bottom[9:5], datablueright_1_bottom[4:0]};
						end
				4'h1 : begin
						if((datablueleft_2_bottom[14:10] !=  0) | (datablueleft_2_bottom[9:5] != 0) | (datablueleft_2_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_2_bottom[14:10], datablueleft_2_bottom[9:5], datablueleft_2_bottom[4:0]};
						end
				4'h5 : begin
						if((datablueleft_1_bottom[14:10] !=  0) | (datablueleft_1_bottom[9:5] != 0) | (datablueleft_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {datablueleft_1_bottom[14:10], datablueleft_1_bottom[9:5], datablueleft_1_bottom[4:0]};
						end
				4'h8 : begin
						if((databluestand_1_bottom[14:10] !=  0) | (databluestand_1_bottom[9:5] != 0) | (databluestand_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluestand_1_bottom[14:10], databluestand_1_bottom[9:5], databluestand_1_bottom[4:0]};
						end
				4'h9 : begin
						if((databluesit_1_bottom[14:10] !=  0) | (databluesit_1_bottom[9:5] != 0) | (databluesit_1_bottom[4:0] != 0))
							{VGA_R[7:3], VGA_G[7:3], VGA_B[7:3]} = {databluesit_1_bottom[14:10], databluesit_1_bottom[9:5], databluesit_1_bottom[4:0]};
						end
				
			endcase
			end
	
	
	        end

	     end
	end

endmodule


module memory(input logic        clk,
			input logic reset,
	      input logic [7:0]  a,
			input logic [7:0]  write_address,
	      input logic [4:0]  din,
	      input logic 	 we,
	      output logic [4:0] dout);
   
   logic [4:0] 			 mem [255:0];
   //logic [7:0] x;
	integer x;
   always_ff @(posedge clk) begin
		if (reset) begin
			x = 0;
			while (x < 255 || x == 255) begin
				
				if ((x > 1  & x < 17) | (x > 203 & x < 219))		mem[x] <= 1;
				else if (((x > 17 & x < 34) | (x > 50 & x < 68) | (x > 84 & x < 102) | (x > 118 & x < 136) | (x > 152 & x < 170) | (x > 186 & x < 203)) & x[0] == 1)		mem[x] <= 1;
				else if ((x > 33 & x < 51) | (x > 67 & x < 85) | (x > 101 & x < 119) | (x > 135 & x < 153) | (x > 169 & x < 187))	mem[x] <= 1;
				else mem[x] <= 0;		
				x = x + 1;
			end
      end else begin
			if (we) mem[write_address] <= din;
			dout <= mem[a];
		end
   end
        
endmodule
