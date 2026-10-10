module FIFO (FIFO_if.DUT f_if);
 
localparam max_fifo_addr = $clog2(f_if.FIFO_DEPTH);

reg [f_if.FIFO_WIDTH-1:0] mem [f_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		wr_ptr <= 0;
		//
		f_if.wr_ack <= 0;
		f_if.overflow <= 0;
	end
	else if (f_if.wr_en && count < f_if.FIFO_DEPTH ) begin
		mem[wr_ptr] <= f_if.data_in;
		f_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		f_if.overflow <= 0; //added
	end
	else begin 
		f_if.wr_ack <= 0; 
		if (f_if.full && f_if.wr_en) //&
			f_if.overflow <= 1;
		else
			f_if.overflow <= 0; 
	end
end


always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		rd_ptr <= 0;
		//
		f_if.data_out  <= 0;
		f_if.underflow <= 0; 
	end
	else if (f_if.rd_en && count != 0) begin
		f_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		//
		f_if.underflow <= 0; 
	end	
	else begin //added
		if (f_if.empty && f_if.rd_en) 
			f_if.underflow <= 1;
		else
			f_if.underflow <= 0; 
	end		
end
always @(posedge f_if.clk or negedge f_if.rst_n) begin
	if (!f_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	((({f_if.wr_en, f_if.rd_en} == 2'b10) && !f_if.full)  || (({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.empty)) 
			count <= count + 1;
		else if ((({f_if.wr_en, f_if.rd_en} == 2'b01) && !f_if.empty) ||(({f_if.wr_en, f_if.rd_en} == 2'b11) && f_if.full))
			count <= count - 1;
	end
end
assign f_if.full = (count == f_if.FIFO_DEPTH)? 1 : 0;
assign f_if.empty = (count == 0)? 1 : 0;
//assign underflow = (empty && rd_en)? 1 : 0; 
assign f_if.almostfull = (count == f_if.FIFO_DEPTH-1)? 1 : 0; //-1
assign f_if.almostempty = (count == 1)? 1 : 0;

//FIFO_2
always_comb begin
if(!f_if.rst_n)
reset_ptr_count_assert: assert final((wr_ptr == 0) && (rd_ptr == 0) && (count == 0));
reset_ptr_count_cover:  cover final((wr_ptr == 0) && (rd_ptr == 0) && (count == 0));
end
//FIFO_3
wr_ack_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ( (f_if.wr_en && !f_if.full) |-> ##1 f_if.wr_ack ));
wr_ack_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ( (f_if.wr_en && !f_if.full) |-> ##1 f_if.wr_ack ));
//FIFO_4
overflow_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.wr_en && f_if.full) |-> ##1 f_if.overflow ));
overflow_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.wr_en && f_if.full) |-> ##1 f_if.overflow ));
//FIFO_5
full_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == f_if.FIFO_DEPTH) |-> f_if.full ));
full_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == f_if.FIFO_DEPTH) |-> f_if.full ));
//FIFO_6
almostfull_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == f_if.FIFO_DEPTH - 1'b1) |-> f_if.almostfull ));
almostfull_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == f_if.FIFO_DEPTH - 1'b1) |-> f_if.almostfull ));
//FIFO_8
underflow_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.rd_en && f_if.empty) |-> ##1 f_if.underflow ));
underflow_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.rd_en && f_if.empty) |-> ##1 f_if.underflow ));
//FIFO_9
empty_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == 0) |-> f_if.empty ));
empty_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == 0) |-> f_if.empty ));
//FIFO_10
almostempty_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == 1) |-> f_if.almostempty ));
almostempty_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((count == 1) |-> f_if.almostempty ));
//FIFO_11
wr_ptr_wraparound_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.wr_en && wr_ptr == f_if.FIFO_DEPTH - 1'b1 && !f_if.full)  |-> ##1 (wr_ptr == 0)));
wr_ptr_wraparound_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.wr_en && wr_ptr == f_if.FIFO_DEPTH - 1'b1 && !f_if.full)  |-> ##1 (wr_ptr == 0)));

rd_ptr_wraparound_assert: assert property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.rd_en && rd_ptr == f_if.FIFO_DEPTH - 1'b1 && !f_if.empty) |-> ##1 (rd_ptr == 0)));
rd_ptr_wraparound_cover:  cover  property (@(posedge f_if.clk) disable iff(!f_if.rst_n) ((f_if.rd_en && rd_ptr == f_if.FIFO_DEPTH - 1'b1 && !f_if.empty) |-> ##1 (rd_ptr == 0)));

reset_count_wrap_assert: assert  property (@(posedge f_if.clk)(!f_if.rst_n && $past(count) == 8 |-> count == 0));
reset_count_wrap_cover: cover  property (@(posedge f_if.clk)(!f_if.rst_n && $past(count) == 8 |-> count == 0));

//FIFO_12
always_comb begin
  pointer_threeshould_assert: assert final( count <= f_if.FIFO_DEPTH && wr_ptr < f_if.FIFO_DEPTH && rd_ptr < f_if.FIFO_DEPTH);
  pointer_threeshould_cover: cover final( count <= f_if.FIFO_DEPTH && wr_ptr < f_if.FIFO_DEPTH && rd_ptr < f_if.FIFO_DEPTH);
end
endmodule

