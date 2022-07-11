`timescale 1ns / 1ps
module BCD_to_onehot(one_hot,dec);
input [0:3]dec;
output reg [0:8] one_hot;
always @(*)
case(dec)
4'd1: one_hot=9'b100000000;
4'd2: one_hot=9'b010000000;
4'd3: one_hot=9'b001000000;
4'd4: one_hot=9'b000100000;
4'd5: one_hot=9'b000010000;
4'd6: one_hot=9'b000001000;
4'd7: one_hot=9'b000000100;
4'd8: one_hot=9'b000000010;
4'd9: one_hot=9'b000000001;
default:one_hot=9'b111111111;
endcase
endmodule


module candidate_type1(completed,sudoku_out,rst,start,clk,sudoku_given);
input [0:323] sudoku_given;
output reg [0:323] sudoku_out;
output completed;
input clk,rst,start;
 reg [0:3] decimal;
 reg [0:323]sudoku_taken;
  wire [0:8]dec_out;
wire [0:3]dec_in;
 wire [0:8]one_hot;
reg [0:728] sudoku;
 reg [0:8] main_element, other_element;
 reg [0:3]count_r,count_c;
 reg [0:3] counter;
reg [0:4] state,next_state;
 wire inc_count_r,inc_count_c,clr_count_r,clr_count_c,inc_counter,clr_counter,filled_cell;
  reg [0:9]position;
 reg [0:80] box;
  reg [0:3] box_num;
  reg [0:8] digit;
  reg update_r,update_c,update_r_2,update_c_2;
  reg [0:3] update_row_num,update_col_num,update_row_num_2,update_col_num_2;
 reg [0:8] cell_val;
  reg update_pencil;
 
 
parameter s0=5'd0,s1_1=5'd1,s1_2=5'd2,
s2_1=5'd3,s2_2=5'd4,s2_3=5'd5,s2_4=5'd6,
s3_1=5'd7,s3_2=5'd8,s3_3=5'd9,s3_4=5'd10,
s4_1=5'd11,s4_2=5'd12,s4_3=5'd13,s4_4=5'd14,
s5_1=5'd15,s5_2=5'd16,s5_3=5'd17,s5_4=5'd18,
s6_1=5'd19,s6_2=5'd20,s6_3=5'd21;

BCD_to_onehot  m1(one_hot,dec_in);

always @(posedge clk)
if(rst==1'b1) state<=s0;
else state <= next_state; 

always @(posedge clk)
if(rst==1'b1) sudoku_out<=324'b0;
else 
begin
if(state==s6_1)sudoku_out<=(sudoku_out<<4);
if(state==s6_2) sudoku_out[320:323]<=decimal;
end

always @(posedge clk)
if(rst==1'b1) sudoku_taken<=324'b0;
else
begin
if(start==1'b1) sudoku_taken<=sudoku_given;
end
  always @(posedge clk)
  if(rst==1'b1) 
  begin
  count_r <=4'd0;
  count_c <=4'd0;
  counter <=4'd0;
  main_element<=9'b0;
  other_element<=9'b0;
  end
  else
  begin
 
        if(inc_count_r) count_r<=count_r+4'd1;
      if(inc_count_c) count_c<=count_c+4'd1;
       if(inc_counter) counter<=counter+4'd1;
      if(clr_count_r) count_r<=4'd0;
      if(clr_count_c) count_c<=4'd0;
    if(clr_counter) counter<=4'd0;
    
    if((state==s2_1)|(state==s3_1)|(state==s4_1))
    main_element<=sudoku[position+:9];
    
    if((state==s2_3)|(state==s3_3)|(state==s4_3))
    other_element<=sudoku[position+:9];
   
  end
  always @(posedge clk)
  if(rst==1'b1)
  begin
  update_c_2<=1'b0;
  update_r_2<=1'b0;
  update_row_num_2<=4'd0;
  update_col_num_2<=4'd0;
  end
  else
  begin
  if(state==s5_2) 
  begin
  update_c_2<=update_c;
  update_r_2<=update_r;
  update_row_num_2<=update_row_num;
  update_col_num_2<=update_col_num;
  end
  end
  
  always @(posedge clk)
  if(rst==1'b1) box<=81'b0;
  else
  begin
   if(state==s5_1) box[(9*counter)+:9]<=sudoku[position+:9];
   end
  
  always @(posedge clk)
  if(rst==1'b1) digit<=9'b0;
  else
  begin
  if((state==s5_1)&(counter==4'd8))
  digit<=9'b100000000;
  if((state==s5_4)&(counter==4'd5))
  begin
  /*if(digit==9'b1)
  digit<=9'b100000000;
  else*/
  digit<=(digit>>1);
  end
  end
  
  always @(posedge clk)
  if(rst==1'b1) box_num<=4'b0;
  else
  begin
  if((state==s5_4)&(digit==9'b1)&(counter==4'd5))
  box_num<=box_num+1'b1;
  end
  
  always @(posedge clk)
  begin
  if(state==s1_2) sudoku[position+:9]<=one_hot;

if(state==s2_4) sudoku[position+:9]<=(count_c!=counter)?((other_element)&(~main_element)):main_element;
if(state==s3_4) sudoku[position+:9]<=(count_r!=counter)?((other_element)&(~main_element)):main_element;
if(state==s4_4) sudoku[position+:9]<=(count_c!=counter)?((other_element)&(~main_element)):main_element;

if((state==s5_3)&(update_r_2))
sudoku[position+:9]<=(sudoku[position+:9]&(~digit));
if((state==s5_4)&(update_c_2))
sudoku[position+:9]<=(sudoku[position+:9]&(~digit));
  end
  
always @(posedge clk)
if(rst==1'b1) update_pencil<=1'b0;
else
begin
if(((state==s2_4)|(state==s3_4)|(state==s4_4))&(other_element!=((other_element)&(~(main_element))))&(other_element!=main_element))
update_pencil<=1'b1;
if((((state==s4_4)&(counter==4'd8))|((state==s4_2)&(!filled_cell)))&(count_r==4'd8)&(count_c==4'd8)) update_pencil<=1'b0;
end

 always @(*)
     case(dec_out) 
     9'd256:decimal=4'h1;
     9'd128:decimal=4'h2;
     9'd64:decimal=4'h3;
     9'd32:decimal=4'h4;
     9'd16:decimal=4'h5;
     9'd8:decimal=4'h6;
     9'd4:decimal=4'h7;
     9'd2:decimal=4'h8;
     9'd1:decimal=4'h9;
     default : decimal=4'h0;
     endcase

always @(*)
case(state)
        s0:next_state=start?s1_1:s0;
        
        s1_1: next_state=s1_2;
        s1_2:next_state=((count_r==4'd8)&(count_c==4'd8))?s2_1:s1_1;
        
        s2_1: next_state=s2_2;
        s2_2:next_state=(filled_cell==1'b1)?s2_3:(((count_c==4'd8)&(count_r==4'd8))?s3_1:s2_1);
        s2_3: next_state=s2_4;
        s2_4:next_state=(counter!=4'd8)?s2_3:(((count_r==4'd8)&(count_c==4'd8))?s3_1:s2_1);
        
        s3_1: next_state=s3_2;
        s3_2:next_state=(filled_cell==1'b1)?s3_3:(((count_c==4'd8)&(count_r==4'd8))?s4_1:s3_1);
        s3_3: next_state=s3_4;
        s3_4:next_state=(counter!=4'd8)?s3_3:(((count_r==4'd8)&(count_c==4'd8))?s4_1:s3_1);
        
        s4_1: next_state=s4_2;
        s4_2:next_state=(filled_cell==1'b1)?s4_3:(((count_c==4'd8)&(count_r==4'd8))?(update_pencil?s2_1:((box_num==4'd9)?s6_1:s5_1)):s4_1);
        s4_3: next_state=s4_4;
        s4_4:next_state=(counter!=4'd8)?s4_3:(((count_r==4'd8)&(count_c==4'd8))?(update_pencil?s2_1:((box_num==4'd9)?s6_1:s5_1)):s4_1);
        
        s5_1:next_state=(counter==4'd8)?s5_2:s5_1;
        s5_2:next_state=s5_3;
        s5_3:next_state=(counter==4'd5)?s5_4:s5_3;
        s5_4:next_state=(counter==4'd5)?((digit==9'b1)?s2_1:s5_2):s5_4;
        
        s6_1:next_state=s6_2;
        s6_2:next_state=(((count_c==4'd8)&(count_r==4'd8))?s6_3:s6_1);
        s6_3:next_state=s6_3;
        default :next_state=s0;
endcase


always @(*)
if(state==s5_2)
case({(|(|(box[0:26]&{3{digit}}))),(|(|(box[27:53]&{3{digit}}))),(|(|(box[54:80]&{3{digit}})))})
3'b100:	begin
                update_r=1'b1;
         update_row_num=(box_num/2'd3)*2'd3+2'd0;
                end
       3'b010:	begin
                update_r=1'b1;
         update_row_num=(box_num/2'd3)*2'd3+2'd1;
                end
       3'b001:	begin
                update_r=1'b1;
         update_row_num=(box_num/2'd3)*2'd3+2'd2;
                end
       default:	begin
                update_r=1'b0;
                update_row_num=4'b0000;
                end
       endcase
       else
       begin
        update_r=1'b0;
        update_row_num=4'b0;
        end

always @(*)
if(state==s5_2)
case({(|(|({box[0:8],box[27:35],box[54:62]}&{3{digit}}))),(|(|({box[9:17],box[36:44],box[63:71]}&{3{digit}}))),(|(|({box[18:26],box[45:53],box[72:80]}&{3{digit}})))})
 3'b100:	begin
                update_c=1'b1;
         update_col_num=(box_num%2'd3)*2'd3+2'd0;
                end
       3'b010:	begin
                update_c=1'b1;
        update_col_num=(box_num%2'd3)*2'd3+2'd1;
                end
       3'b001:	begin
                update_c=1'b1;
         update_col_num=(box_num%2'd3)*2'd3+2'd2;
                end
       default:	begin
                update_c=1'b0;
                update_col_num=4'b0000;
                end
       endcase
       else
       begin
        update_c=1'b0;
        update_col_num=4'b0000;
        end

always @(*)
case(state)
s1_2:position=(81*count_r+9*count_c);
s2_1:position=(81*count_r+9*count_c);
s2_3:position=(81*count_r+9*counter);
s2_4:position=(81*count_r+9*counter);
s3_1:position=(81*count_r+9*count_c);
s3_3:position=(81*counter+9*count_c);
s3_4:position=(81*counter+9*count_c);
s4_1:position=(81*((count_r/2'd3)*2'd3+(count_c/2'd3))+9*((count_r%2'd3)*2'd3+(count_c%2'd3)));
s4_3:position=(81*((count_r/2'd3)*2'd3+(counter/2'd3))+9*((count_r%2'd3)*2'd3+(counter%2'd3)));
s4_4:position=(81*((count_r/2'd3)*2'd3+(counter/2'd3))+9*((count_r%2'd3)*2'd3+(counter%2'd3)));
s5_1:position=(81*((box_num/2'd3)*2'd3+(counter/2'd3))+9*((box_num%2'd3)*2'd3+(counter%2'd3)));

s5_3:	case(box_num)
                4'd0,4'd3,4'd6:
                	begin
                	case(counter)
                      4'd0:position=(81*update_row_num_2)+27;
                     4'd1:position=81*update_row_num_2+36;
                     4'd2:position=81*update_row_num_2+45;
                      4'd3:position=81*update_row_num_2+54;
                      4'd4:position=81*update_row_num_2+63;
                      4'd5:position=81*update_row_num_2+72;
                      default:position=10'b1111111111;
                      endcase
					 end    
                4'd1,4'd4,4'd7:
                	begin
                	case(counter)
                      4'd0:position=81*update_row_num_2;
                     4'd1:position=81*update_row_num_2+9;
                     4'd2:position=81*update_row_num_2+18;
                      4'd3:position=81*update_row_num_2+54;
                      4'd4:position=81*update_row_num_2+63;
                      4'd5:position=81*update_row_num_2+72;
                      default:position=10'b1111111111;
                      endcase
                      end
                4'd2,4'd5,4'd8:
               	 	begin
               	 	case(counter)
               	 	 4'd0:position=81*update_row_num_2;
                     4'd1:position=81*update_row_num_2+9;
                     4'd2:position=81*update_row_num_2+18;
                      4'd3:position=81*update_row_num_2+27;
                     4'd4:position=81*update_row_num_2+36;
                     4'd5:position=81*update_row_num_2+45;
                      default:position=10'b1111111111;
                      endcase
					 end
			default: position=10'b1111111111;
                endcase
                
s5_4:case(box_num)
                4'd0,4'd1,4'd2:
                	begin
                	case(counter)
                      4'd0:position=243+9*update_col_num_2;
                     4'd1:position=324+9*update_col_num_2;
                     4'd2:position=405+9*update_col_num_2;
                      4'd3:position=486+9*update_col_num_2;
                      4'd4:position=567+9*update_col_num_2;
                      4'd5:position=648+9*update_col_num_2;
                      default:position=10'b1111111111;
                      endcase
					 end    
                4'd3,4'd4,4'd5:
                	begin
                	case(counter)
                      4'd0:position=9*update_col_num_2;
                     4'd1:position=81+9*update_col_num_2;
                     4'd2:position=162+9*update_col_num_2;
                      4'd3:position=486+9*update_col_num_2;
                      4'd4:position=567+9*update_col_num_2;
                      4'd5:position=648+9*update_col_num_2;
                      default:position=10'b1111111111;
                      endcase
					 end
                4'd6,4'd7,4'd8:
               	 	begin
               	 	case(counter)
                      4'd0:position=9*update_col_num_2;
                     4'd1:position=81+9*update_col_num_2;
                     4'd2:position=162+9*update_col_num_2;
                      4'd3:position=243+9*update_col_num_2;
                      4'd4:position=324+9*update_col_num_2;
                      4'd5:position=405+9*update_col_num_2;
                      default:position=10'b1111111111;
                      endcase
					 end
					 default: position=10'b1111111111;
                endcase
                
default:position=10'b1111111111;
endcase

assign dec_in=((state==s1_1)|(state==s1_2))?sudoku_taken[(36*count_r+4*count_c)+:4]:4'b0;
assign inc_count_r=((((state==s1_2)|(state==s6_2))|(((state==s2_2)|(state==s3_2)|(state==s4_2))&(filled_cell!=1'b1))|(((state==s2_4)|(state==s3_4)|(state==s4_4))&(counter==4'd8)))&((count_c==4'd8)&(count_r!=4'd8)));
  assign inc_count_c=((((state==s1_2)|(state==s6_2))|(((state==s2_4)|(state==s3_4)|(state==s4_4))&(counter==4'd8))|(((state==s2_2)|(state==s3_2)|(state==s4_2))&(filled_cell!=1'b1)))&(count_c!=4'd8));
  assign inc_counter=(((((state==s2_4)|(state==s3_4)|(state==s4_4)))&(counter!=4'd8))|((state==s5_1)&(counter!=4'd8))|(((state==s5_3)|(state==s5_4))&(counter!=4'd5)));
  assign clr_count_r=((((state==s1_2)|(state==s6_2))|(((state==s2_4)|(state==s3_4|(state==s4_4)))&(counter==4'd8))|(((state==s2_2)|(state==s3_2)|(state==s4_2))&(filled_cell!=1'b1)))&((count_c==4'd8)&(count_r==4'd8)));
  assign clr_count_c=((((state==s1_2)|(state==s6_2))|(((state==s2_4)|(state==s3_4)|(state==s4_4))&(counter==4'd8))|(((state==s2_2)|(state==s3_2|(state==s4_2)))&(filled_cell!=1'b1)))&(count_c==4'd8));
  assign  clr_counter=(((((state==s2_4)|(state==s3_4)|(state==s4_4)|(state==s5_1))&(counter==4'd8)))|(((state==s5_3)|(state==s5_4))&(counter==4'd5)));
 assign completed=(state==s6_3);
assign dec_out=((state==s6_1)|(state==s6_2))?sudoku[(81*count_r+9*count_c)+:9]:9'b0;
assign filled_cell=((main_element==9'd1)|(main_element==9'd2)|(main_element==9'd4)|(main_element==9'd8)|(main_element==9'd16)|(main_element==9'd32)|(main_element==9'd64)|(main_element==9'd128)|(main_element==9'd256));
endmodule


