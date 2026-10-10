package FIFO_scoreboard_pkg;

import FIFO_transaction_pkg::*;
import FIFO_shared_pkg::*;
class FIFO_scoreboard;


logic [FIFO_WIDTH-1:0] data_out_ref; 
logic wr_ack_ref, overflow_ref, underflow_ref;
logic full_ref, empty_ref, almostfull_ref, almostempty_ref;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

logic [FIFO_WIDTH-1:0] fifo_queue[$];
logic [max_fifo_addr:0] count;

task check_data(input FIFO_transaction F_txn);
 logic	[6:0]	flags_ref , flags_dut;
//FIFO_1,FIFO_7
 refrence_model(F_txn);
    if( (data_out_ref != F_txn.data_out))   begin
      $display("Incorrect Result rst_n=%d,data_in=%d,wr_en=%d,rd_en=%d,data_out=%d,data_out_ref=%d",
                        F_txn.rst_n,F_txn.data_in,F_txn.wr_en,F_txn.rd_en,F_txn.data_out,data_out_ref);
      error_count = error_count + 1;
  end
  else begin
     correct_count = correct_count + 1;
  end
endtask

task refrence_model(input FIFO_transaction F_txn);
fork
    begin
       if (!F_txn.rst_n) begin
       		wr_ack_ref = 0;
       		overflow_ref = 0;
            fifo_queue.delete();	
       	end
       	else if (F_txn.wr_en && count < FIFO_DEPTH) begin
       		fifo_queue.push_back(F_txn.data_in);
       		wr_ack_ref = 1;
       		overflow_ref = 0; //added
       	end
       	else begin 
       		wr_ack_ref = 0; 
       		if (full_ref && F_txn.wr_en) 
       			overflow_ref = 1;
       		else
       			overflow_ref = 0; 
       	end
    end
    begin
	    if (!F_txn.rst_n) begin
	    	data_out_ref  = 0;
	    	underflow_ref = 0; 
	    end
	    else if (F_txn.rd_en && count != 0) begin
	    	data_out_ref = fifo_queue.pop_front();
	    	underflow_ref = 0; 
	    end	
	    else begin 
	    	if (empty_ref && F_txn.rd_en) 
	    		underflow_ref = 1;
	    	else
	    	    underflow_ref = 0; 
	    end		       
    end

    begin
        if (!F_txn.rst_n) begin
	    	count = 0;
	    end
	    else begin
	    	if	((({F_txn.wr_en, F_txn.rd_en} == 2'b10) && !full_ref)  || (({F_txn.wr_en, F_txn.rd_en} == 2'b11) && empty_ref)) 
	    		count = count + 1;
	    	else if ((({F_txn.wr_en, F_txn.rd_en} == 2'b01) && !empty_ref) ||(({F_txn.wr_en, F_txn.rd_en} == 2'b11) && full_ref))
	    		count = count - 1;
	    end
        end
      
join
    full_ref        = (count == FIFO_DEPTH)? 1 : 0;
    empty_ref       = (count == 0)? 1 : 0;
    almostfull_ref  = (count == FIFO_DEPTH-1)? 1 : 0; 
    almostempty_ref = (count == 1)? 1 : 0;
endtask

endclass
endpackage
