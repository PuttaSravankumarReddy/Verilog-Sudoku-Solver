
module full_house(Rf,Ri);
  input [36:1] Ri;
  output reg [36:1] Rf;
  wire [6:1] sum;
  assign sum=Ri[4:1]+Ri[8:5]+Ri[12:9]+Ri[16:13]+Ri[20:17]+Ri[24:21]+Ri[28:25]+Ri[32:29]+Ri[36:33];
  always @(*)
    begin case({|Ri[4:1],|Ri[8:5],|Ri[12:9],|Ri[16:13],|Ri[20:17],|Ri[24:21],|Ri[28:25],|Ri[32:29],|Ri[36:33]})
 ~9'd1 : begin
Rf[32:1]<=Ri[32:1];
   Rf[36:33]<=6'd45-sum;
end
~9'd2 : begin
Rf[28:1]<=Ri[28:1];
Rf[36:33]<=Ri[36:33];
  Rf[32:29]<=6'd45-sum;
end
~9'd4 : begin
Rf[24:1]<=Ri[24:1];
Rf[36:29]<=Ri[36:29];
  Rf[28:25]<=6'd45-sum;
end
~9'd8 : begin
Rf[20:1]<=Ri[20:1];
Rf[36:25]<=Ri[36:25];
  Rf[24:21]<=6'd45-sum;
end
~9'd16 : begin
Rf[16:1]<=Ri[16:1];
Rf[36:21]<=Ri[36:21];
  Rf[20:17]<=6'd45-sum;
end
~9'd32 : begin
Rf[12:1]<=Ri[12:1];
Rf[36:17]<=Ri[36:17];
  Rf[16:13]<=6'd45-sum;
end
~9'd64 : begin
Rf[8:1]<=Ri[8:1];
Rf[36:13]<=Ri[36:13];
  Rf[12:9]<=6'd45-sum;
end
~9'd128 : begin
Rf[4:1]<=Ri[4:1];
Rf[36:9]<=Ri[36:9];
  Rf[8:5]<=6'd45-sum;
end
~9'd256  : begin
Rf[36:5]<=Ri[36:5];
  Rf[4:1]<=6'd45-sum;
end
 default : Rf<=Ri;
        endcase
    end
endmodule

module solve_sudoku_fullhouse(sudoku,completed,sudoku_given,clk,rst,start);
  input [0:323] sudoku_given;
output completed;
input clk,rst,start;
  output reg [0:323]sudoku;
  reg [0:323]sudoku2;
  reg [0:3] state,next_state;
  reg [0:3] count;
  reg [0:35]Ri;
  wire [0:35]Rf;
  reg same;
  parameter s0=4'd0, s1=4'd1, s2=4'd2, s3=4'd3, s4=4'd4, s5=4'd5,s6=4'd6; 
  
  full_house    d1(Rf,Ri);
  
  always @(posedge clk)
if(rst==1'b1) state<=s0;
else state <= next_state; 
  
  always @(posedge clk)
    if(rst==1'b1) 
    begin
    sudoku<=324'b0;
     end  
else
begin
  if(state==s1)
  begin 
  sudoku<=sudoku_given;
  end
  else if(state==s2) 
    begin
      sudoku[36*count+:36]<=Rf;  
    end
  else if(state==s3) 
    begin {sudoku[(4*count)+:4],sudoku[(36+4*count)+:4],sudoku[(72+4*count)+:4],sudoku[(108+4*count)+:4],sudoku[(144+4*count)+:4],sudoku[(180+4*count)+:4],sudoku[(216+4*count)+:4],sudoku[(252+4*count)+:4],sudoku[(288+4*count)+:4]}<=Rf;  
    end
  else if(state==s4) 
    begin
      case(count)
        4'd0,4'd1,4'd2:begin
          {sudoku[12*count+:12],sudoku[(36+12*count)+:12],sudoku[(72+12*count)+:12]}<=Rf;
        			  end
        4'd3,4'd4,4'd5:begin
          {sudoku[(72+12*count)+:12],sudoku[(108+12*count)+:12],sudoku[(144+12*count)+:12]}<=Rf;
        			  end
        4'd6,4'd7,4'd8:begin
          {sudoku[(144+12*count)+:12],sudoku[(180+12*count)+:12],sudoku[(216+12*count)+:12]}<=Rf;
        			  end
      endcase
    end
end
  
   always @(posedge clk)
    if(rst==1'b1) sudoku2<=324'b0;
    else 
    begin
    if(state==s1)  sudoku2<=sudoku_given;
         else if(state==s5) sudoku2<=sudoku;  
         end
         
  always @(posedge clk)
  begin
    if(rst==1'b1) count<=4'd0;
    else count<=((state==s2)|(state==s3)|(state==s4))?((count==4'd8)?4'd0:(count+4'd1)):count;
  end
  
  always @(*)
    case(state)
      s0: next_state=(start==1'b1)?s1:s0;
      
      s1: next_state=s2;
      
      s2: next_state=(count==4'd8)?s3:s2;
      
      s3: next_state=(count==4'd8)?s4:s3;
      
      s4: next_state=(count==4'd8)?s5:s4;
      
      s5: next_state=same?s6:s2;
     	//use reset to load new data
    endcase
    
  
  always @(*)
    begin
     if(state==s2) 
    begin
      Ri=sudoku[36*count+:36];  
    end
  else if(state==s3) 
    begin 
      Ri={sudoku[(4*count)+:4],sudoku[(36+4*count)+:4],sudoku[(72+4*count)+:4],sudoku[(108+4*count)+:4],sudoku[(144+4*count)+:4],sudoku[(180+4*count)+:4],sudoku[(216+4*count)+:4],sudoku[(252+4*count)+:4],sudoku[(288+4*count)+:4]};  
    end
  else if(state==s4) 
    begin
      case(count)
        4'd0,4'd1,4'd2:begin
          Ri={sudoku[12*count+:12],sudoku[(36+12*count)+:12],sudoku[(72+12*count)+:12]};
        			  end
        4'd3,4'd4,4'd5:begin
          Ri={sudoku[(72+12*count)+:12],sudoku[(108+12*count)+:12],sudoku[(144+12*count)+:12]};
        			  end
        4'd6,4'd7,4'd8:begin
          Ri={sudoku[(144+12*count)+:12],sudoku[(180+12*count)+:12],sudoku[(216+12*count)+:12]};
        			  end
      endcase
    end 
    end
  
  always @(*)
  begin
  if(rst==1'b1) same=1'b0;
  else if(state==s5) same=(|(sudoku^sudoku2))?1'b0:1'b1;
  end
    assign completed=(state==s6);
   
  endmodule
