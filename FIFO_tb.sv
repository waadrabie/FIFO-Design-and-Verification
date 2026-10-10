import FIFO_shared_pkg::*;
import FIFO_transaction_pkg::*;

module FIFO_tb(FIFO_if.TEST f_if);

FIFO_transaction F_tb_txn;
initial begin

F_tb_txn = new;
#0 f_if.rst_n =1; #0
f_if.rst_n = 0;
f_if.wr_en = 0;
f_if.rd_en = 0;
f_if.data_in = 0;
@(negedge f_if.clk);
f_if.rst_n = 1;

//Write only
F_tb_txn.constraint_mode(0);
F_tb_txn.c_write_only.constraint_mode(1);
F_tb_txn.c_rst_n.constraint_mode(1);

repeat(1000) begin
assert(F_tb_txn.randomize());
 f_if.data_in     = F_tb_txn.data_in;
 f_if.rst_n       = F_tb_txn.rst_n;
 f_if.wr_en       = F_tb_txn.wr_en;
 f_if.rd_en       = F_tb_txn.rd_en;
 @(negedge f_if.clk);
  ->trigger;
end

//read only
F_tb_txn.constraint_mode(0);
F_tb_txn.c_read_only.constraint_mode(1);
F_tb_txn.c_rst_n.constraint_mode(1);

repeat(1000) begin
assert(F_tb_txn.randomize());
 f_if.data_in     = F_tb_txn.data_in;
 f_if.rst_n       = F_tb_txn.rst_n;
 f_if.wr_en       = F_tb_txn.wr_en;
 f_if.rd_en       = F_tb_txn.rd_en;
  @(negedge f_if.clk);
 ->trigger;
end

// read and write
F_tb_txn.constraint_mode(1);
F_tb_txn.c_write_only.constraint_mode(0);
F_tb_txn.c_read_only.constraint_mode(0);
repeat(10000) begin
assert(F_tb_txn.randomize());
 f_if.data_in     = F_tb_txn.data_in;
 f_if.rst_n       = F_tb_txn.rst_n;
 f_if.wr_en       = F_tb_txn.wr_en;
 f_if.rd_en       = F_tb_txn.rd_en;
 @(negedge f_if.clk);
 ->trigger;

end

test_finished = 1;
end

endmodule
