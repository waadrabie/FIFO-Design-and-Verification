import FIFO_shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;

module FIFO_monitor (FIFO_if.MONITOR f_if);

FIFO_transaction F_mon_txn;
FIFO_coverage    F_mon_cov;
FIFO_scoreboard  F_mon_sb;

initial begin
 F_mon_txn = new;
 F_mon_cov = new;
 F_mon_sb  = new;
 forever begin
 wait(trigger.triggered);
  @(negedge f_if.clk);
  F_mon_txn.data_in     = f_if.data_in;
  F_mon_txn.rst_n       = f_if.rst_n;
  F_mon_txn.wr_en       = f_if.wr_en;
  F_mon_txn.rd_en       = f_if.rd_en;
  F_mon_txn.data_out    = f_if.data_out; 
  F_mon_txn.full        = f_if.full;
  F_mon_txn.almostfull  = f_if.almostfull;
  F_mon_txn.empty       = f_if.empty;
  F_mon_txn.almostempty = f_if.almostempty;
  F_mon_txn.overflow    = f_if.overflow;
  F_mon_txn.underflow   = f_if.underflow;
  F_mon_txn.wr_ack      = f_if.wr_ack;
 
fork
	begin   
		F_mon_cov.sample_data(F_mon_txn);
	end

	begin  		                 
		F_mon_sb.check_data(F_mon_txn);
	end
join

 if(test_finished == 1) begin
	$display("error_count=%d ,correct_count=%d", error_count , correct_count);
	$stop;
 end
end
end
endmodule
