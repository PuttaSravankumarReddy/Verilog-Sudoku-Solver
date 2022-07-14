`timescale 1ns / 1ps
module t_test;
  reg clk,rst,start;
  reg [0:323]sudoku_given;
  wire completed;
  wire [0:323] sudoku_out;
 candidate_type1     m1(completed,sudoku_out,rst,start,clk,sudoku_given);
  initial
    begin
     rst=1'b0;
      start=1'b0;
       #8 rst=1'b1;
      #152 rst=1'b0;
      #1 sudoku_given=324'h735468912064139058819527463978613524126954837453782196342891675681275349097346081;
      #1 start=1'b1;
      #10 @(completed)
      $display($time);
       #5 $write("%81h",sudoku_out);
      #10 $finish;
      end  
  initial
    begin
      clk=1'b0;
      forever
        #5 clk=~clk;
    end
endmodule
