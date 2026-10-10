module top;

bit clk;

initial begin
    clk = 0;
    forever 
        #1 clk = ~clk;    
end
 
 //FIFO_1  
always_comb begin
if(!f_if.rst_n)
reset_assert: assert final({f_if.data_out,f_if.wr_ack, f_if.overflow, f_if.full, f_if.empty, f_if.almostfull, f_if.almostempty, f_if.underflow} == 8'b00001000);
reset_cover:  cover final({f_if.data_out,f_if.wr_ack, f_if.overflow, f_if.full, f_if.empty, f_if.almostfull, f_if.almostempty, f_if.underflow} == 8'b00001000);
end

FIFO_if f_if(clk);
FIFO    dut (f_if);
FIFO_tb tb  (f_if);
FIFO_monitor monitor  (f_if);
endmodule
