`timescale 1ns/1ps
module t_full_house;
  wire [0:323] sudoku;
  wire completed;
  reg [0:323] sudoku_given;
  reg clk,rst,start;
  solve_sudoku_fullhouse   m1(sudoku,completed,sudoku_given,clk,rst,start);
initial 
begin  
  #1 clk=1'b0;
  #1 rst=1'b1;
  #1 start=1'b0;
  sudoku_given=324'h183950246950106078726380195300812000472695813010473529501239784230740651847501032;
  #5 rst=1'b0;
  #1 start=1'b1;
  
  #10000 
  $write("ans-  %h",sudoku);
  
#500 $finish;
end
  initial
    begin
      repeat(10000)
       #5 clk =~clk;
    end
endmodule
