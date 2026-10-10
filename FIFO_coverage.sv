package FIFO_coverage_pkg;

import FIFO_transaction_pkg::*;
class FIFO_coverage;

FIFO_transaction F_cvg_txn;

covergroup cvr_grp; 
wr_en_cp : coverpoint F_cvg_txn.wr_en;
rd_en_cp : coverpoint F_cvg_txn.rd_en;

full_cp        : coverpoint F_cvg_txn.full  iff (F_cvg_txn.rst_n);
almostfull_cp  : coverpoint F_cvg_txn.almostfull iff (F_cvg_txn.rst_n);
empty_cp       : coverpoint F_cvg_txn.empty iff (F_cvg_txn.rst_n);
almostempty_cp : coverpoint F_cvg_txn.almostempty iff (F_cvg_txn.rst_n);
overflow_cp	   : coverpoint F_cvg_txn.overflow iff (F_cvg_txn.rst_n);
underflow_cp   : coverpoint F_cvg_txn.underflow iff (F_cvg_txn.rst_n);
wr_ack_cp      : coverpoint F_cvg_txn.wr_ack iff (F_cvg_txn.rst_n);


//FIFO_3
wr_ack_cross      : cross wr_en_cp , rd_en_cp , wr_ack_cp {
                            ignore_bins bins_wr_L_rd_ack_H = binsof(wr_en_cp) intersect{0}  && binsof(rd_en_cp) && binsof(wr_ack_cp) intersect{1} ;}
//FIFO_4
overflow_cross    : cross wr_en_cp , rd_en_cp , overflow_cp {
                            ignore_bins bins_wr_L_rd_overflow_H = binsof(wr_en_cp) intersect{0}  && binsof(rd_en_cp) && binsof(overflow_cp) intersect{1} ;}                            
//FIFO_5
full_cross        : cross wr_en_cp , rd_en_cp , full_cp {
                           ignore_bins bins_wr_rd_H_full_H = binsof(wr_en_cp)  && binsof(rd_en_cp) intersect{1} && binsof(full_cp) intersect{1} ;}
//FIFO_6                           
almostfull_cross  : cross wr_en_cp , rd_en_cp , almostfull_cp ;
//FIFO_8
underflow_cross   : cross wr_en_cp , rd_en_cp , underflow_cp {
                           ignore_bins bins_wr_rd_L_underflow_H = binsof(wr_en_cp)  && binsof(rd_en_cp) intersect{0} && binsof(underflow_cp) intersect{1} ;}
//FIFO_9
empty_cross       : cross wr_en_cp , rd_en_cp , empty_cp {
                            ignore_bins bins_wr_H_rd_empty_H = binsof(wr_en_cp) intersect{1}  && binsof(rd_en_cp) && binsof(empty_cp) intersect{1} ;}
//FIFO_10                            
almostempty_cross : cross wr_en_cp , rd_en_cp , almostempty_cp;

endgroup    

function new();
cvr_grp = new;
F_cvg_txn = new;
endfunction

function void sample_data(input FIFO_transaction F_txn);
 F_cvg_txn = F_txn;
 cvr_grp.sample();
endfunction

endclass
endpackage
