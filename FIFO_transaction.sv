package FIFO_transaction_pkg;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class FIFO_transaction;

rand logic [FIFO_WIDTH-1:0] data_in; 
rand logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out; 
logic wr_ack, overflow, underflow;
logic full, empty, almostfull, almostempty;

integer RD_EN_ON_DIST , WR_EN_ON_DIST;
function new (integer RD_EN_ON_DIST  = 30 ,integer WR_EN_ON_DIST = 70);
this.RD_EN_ON_DIST = RD_EN_ON_DIST;
this.WR_EN_ON_DIST = WR_EN_ON_DIST;  
endfunction
//FIFO_1
constraint c_rst_n  { rst_n   dist{0:=5, 1:=95};}
//FIFO_3
constraint c_wr_en  { wr_en   dist{0:=100-WR_EN_ON_DIST, 1:=WR_EN_ON_DIST};}
constraint c_write_only { wr_en == 1; rd_en == 0;}
//FIFO_7
constraint c_rd_en  { rd_en   dist{0:=100-RD_EN_ON_DIST, 1:=RD_EN_ON_DIST};}
constraint c_read_only  { wr_en == 0; rd_en == 1;}
endclass
endpackage
 