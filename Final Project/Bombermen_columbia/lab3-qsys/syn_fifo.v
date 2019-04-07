/-----------------------------------------------------
   // Design Name : syn_fifo
   // File Name   : syn_fifo.v
   // Function    : Synchronous (single clock) FIFO
   // Coder       : Deepak Kumar Tala
   //-----------------------------------------------------
   module syn_fifo (
   clk      , // Clock input
   rst      , // Active high reset
   wr_cs    , // Write chip select
   rd_cs    , // Read chipe select
   data_in  , // Data input
   rd_en    , // Read enable
   wr_en    , // Write Enable
   data_out , // Data Output
   empty    , // FIFO empty
   full       // FIFO full
  );    
    
   // FIFO constants
   parameter DATA_WIDTH = 8;
   parameter ADDR_WIDTH = 8;
   parameter RAM_DEPTH = (1 << ADDR_WIDTH);
   // Port Declarations
   input clk ;
   input rst ;
   input wr_cs ;
   input rd_cs ;
   input rd_en ;
   input wr_en ;
   input [DATA_WIDTH-1:0] data_in ;
   output full ;
   output empty ;
   output [DATA_WIDTH-1:0] data_out ;
   
   //-----------Internal variables-------------------
  37 reg [ADDR_WIDTH-1:0] wr_pointer;
  38 reg [ADDR_WIDTH-1:0] rd_pointer;
  39 reg [ADDR_WIDTH :0] status_cnt;
  40 reg [DATA_WIDTH-1:0] data_out ;
  41 wire [DATA_WIDTH-1:0] data_ram ;
  42 
  43 //-----------Variable assignments---------------
  44 assign full = (status_cnt == (RAM_DEPTH-1));
  45 assign empty = (status_cnt == 0);
  46 
  47 //-----------Code Start---------------------------
  48 always @ (posedge clk or posedge rst)
  49 begin : WRITE_POINTER
  50   if (rst) begin
  51     wr_pointer <= 0;
  52   end else if (wr_cs && wr_en ) begin
  53     wr_pointer <= wr_pointer + 1;
  54   end
  55 end
  56 
  57 always @ (posedge clk or posedge rst)
  58 begin : READ_POINTER
  59   if (rst) begin
  60     rd_pointer <= 0;
  61   end else if (rd_cs && rd_en ) begin
  62     rd_pointer <= rd_pointer + 1;
  63   end
  64 end
  65 
  66 always  @ (posedge clk or posedge rst)
  67 begin : READ_DATA
  68   if (rst) begin
  69     data_out <= 0;
  70   end else if (rd_cs && rd_en ) begin
  71     data_out <= data_ram;
  72   end
  73 end
  74 
  75 always @ (posedge clk or posedge rst)
  76 begin : STATUS_COUNTER
  77   if (rst) begin
  78     status_cnt <= 0;
  79   // Read but no write.
  80   end else if ((rd_cs && rd_en) &&  ! (wr_cs && wr_en) 
  81                 && (status_cnt  ! = 0)) begin
  82     status_cnt <= status_cnt - 1;
  83   // Write but no read.
  84   end else if ((wr_cs && wr_en) &&  ! (rd_cs && rd_en) 
  85                && (status_cnt  ! = RAM_DEPTH)) begin
  86     status_cnt <= status_cnt + 1;
  87   end
  88 end 
  89    
  90 ram_dp_ar_aw #(DATA_WIDTH,ADDR_WIDTH)DP_RAM (
  91 .address_0 (wr_pointer) , // address_0 input 
  92 .data_0    (data_in)    , // data_0 bi-directional
  93 .cs_0      (wr_cs)      , // chip select
  94 .we_0      (wr_en)      , // write enable
  95 .oe_0      (1'b0)       , // output enable
  96 .address_1 (rd_pointer) , // address_q input
  97 .data_1    (data_ram)   , // data_1 bi-directional
  98 .cs_1      (rd_cs)      , // chip select
  99 .we_1      (1'b0)       , // Read enable
 100 .oe_1      (rd_en)        // output enable
 101 );     
 102 
 103 endmodule
