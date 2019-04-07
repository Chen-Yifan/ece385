module audio_effects (
    input  clk,
    input reset,
    input   sample_end,
    input  [1:0]sample_req,
    output [15:0] audio_output,
    input  [15:0] audio_input,
	 input  SW_mute,
    input  [3:0]  control
	 //output ready
	 //output [2:0] test
	 
);



reg [15:0] last_sample;
reg [15:0] dat;
reg  readyToaccept;


assign audio_output = dat;
//assign ready = readyToaccept;
//assign test =state;


reg[2:0] state;





reg	[16:0]  address0;
wire	[15:0]  q0;

BGM audio0( //120001
	.address(address0),
	.clock(clk),
	.q(q0)
);

	
	
reg	[10:0]  address1;
wire	[15:0]  q1;

bomb_drop audio1( //1882
	.address(address1),
	.clock(clk),
	.q(q1)
	
);	
	

	
reg	[14:0]  address2;
wire	[15:0]  q2;
bomb_explode audio2(//29536

   .address(address2),
	.clock(clk),
	.q(q2)
);



reg	[15:0]  address3;
wire	[15:0]  q3;		

player_win audio3( // 35200
	.address(address3),
	.clock(clk),
	.q(q3)
	
);

//reg	[14:0]  address4;
//wire  [7:0]  q4;	
//
//bomb_explode2 audio4( //20384
//	.address(address4),
//	.clock(clk),
//	.q(q4)
//);

	

	
always @(posedge clk) begin

	if(reset) begin
		state<=0;
		//readyToaccept<=0;
		 address0 <= 0;
		 address1 <= 0;
		 address2 <= 0;
		 address3 <= 0;
		
	end else 
	 
    if (sample_end) begin
        last_sample <= audio_input;
    end
	 
	 
	 
	 dat<=0;
	 if (sample_req[0]) begin
	  
	 
	 //case(state) 
 
    //0:begin
	   //readyToaccept<=1;
	   address0<=address0+1;
      
      if(!SW_mute)begin	
		dat<=q0;
      end      
		if(address0==120001) begin
		   address0 <= 0;
		end
	 end else if(sample_req[1])begin  
	//end else if(sample_req[1]) begin
	   
      
   case(state) 
 
     0:begin

		case(control) 
		  
		 // 0: ;
		  4'b0001: begin // bomb drop
		      //readyToaccept<=1;
				address1<=0;
            //dat <= q1;
            state<=1;
			  end
		 4'b0010: begin // bomb explode
		    //  readyToaccept<=1;
		 		address2<=0;
            dat <= q2;
            state<=2;
			  end
		 4'b0100:  begin // player win
		    //  readyToaccept<=0;
				address3<=0;
            dat <= q3;
            state<=3;
			  end
			  
//		  4'b0111: begin // item pickup
//		      readyToaccept<=0;
//				address4<=address4+1;
//            dat <= q4;
//            state<=4;
//			  end
			  
		 default: ;
		  
		     
		     
            
		  
		  endcase
		
	end
		  
	 1: begin
	 
	     address1<=address1+1;
        dat <= q1;
            if (address1==1882) begin
                address1 <= 0;
					 state<=0;
				end
				
				
		   case(control) 
		  
		 // 0: ;
		  4'b0001: begin // bomb drop
		     // readyToaccept<=1;
				address1<=0;
            dat <= q1;
            state<=1;
			  end
		   4'b0010: begin // bomb explode
		     // readyToaccept<=1;
		 		address2<=0;
            dat <= q2;
            state<=2;
			  end
		   4'b0100:  begin // player win
		     // readyToaccept<=0;
				address3<=0;
            dat <= q3;
            state<=3;
			  end
			  
//		  4'b0111: begin // item pickup
//		      readyToaccept<=0;
//				address4<=address4+1;
//            dat <= q4;
//            state<=4;
//			  end
			  
		 default: ;
		  
		     
		     
            
		  
		  endcase
	 
	    end
		 
		 
	 2: begin
	 
	     address2<=address2+1;
        dat <= q2;
            if (address2==29536) begin
                address2 <= 0;
					 state<=0;
				end
				
				
		   case(control) 
		  
		 // 0: ;
		  4'b0001: begin // bomb drop
		      //readyToaccept<=1;
				address1<=0;
            dat <= q1;
            state<=1;
			  end
		  4'b0010: begin // bomb explode
		     // readyToaccept<=1;
		 		address2<=0;
            dat <= q2;
            state<=2;
			  end
		   4'b0100:  begin // player win
		     // readyToaccept<=0;
				address3<=0;
            dat <= q3;
            state<=3;
			  end
			  
//		  4'b0111: begin // item pickup
//		      readyToaccept<=0;
//				address4<=address4+1;
//            dat <= q4;
//            state<=4;
//			  end
			  
		 default: ;
		  
		     
		     
            
		  
		  endcase
	 
	    end
        
		  
	 3: begin
	 
	     address3<=address3+1;
        dat <= q3;
            if (address3==35200) begin
                address3 <= 0;
					 state<=0;
				end
			 case(control) 
		  
		 // 0: ;
		  4'b0001: begin // bomb drop
		    //  readyToaccept<=1;
				address1<=0;
            dat <= q1;
            state<=1;
			  end
		   4'b0010: begin // bomb explode
		   //   readyToaccept<=1;
		 		address2<=0;
            dat <= q2;
            state<=2;
			  end
		    4'b0100:  begin // player win
		     // readyToaccept<=0;
				address3<=0;
            dat <= q3;
            state<=3;
			  end
			  
//		  4'b0111: begin // item pickup
//		      readyToaccept<=0;
//				address4<=address4+1;
//            dat <= q4;
//            state<=4;
//			  end
			  
		 default: ;
		  
		     
		     
            
		  
		  endcase
	 
	    end
        
//	 4: begin
//	 
//	     address4<=address4+1;
//        dat <= q4;
//            if (address4==29536) begin
//                address4 <= 0;
//					 state<=0;
//				end
//	 
//	    end
		 
	
		  
		  
		  
		  
		  
		  
		  
		  
		  
		
		 
		endcase	
	end
   end


//assign stateout=~state;

endmodule
