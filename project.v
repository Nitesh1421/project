module FPM(underflow , overflow , M , A , B);
input [31:0]A , B;
output [31:0]M;
wire [7:0]expo_sum;
wire temp;
//sign bit
  assign temp = A[31] ^ B[31];
  
//Addition of Exponent..
wire [7:0]summ;
wire cout;
CLA_8 C7(summ , cout , A[30:23] , B[30:23] , 1'b0);

//Substract 127 from Exponent..Because it will get added twice during multiplication.
wire [8:0]diff_new;
wire under;
output underflow;
substractor_8 S0(diff_new , under ,{cout, summ}); //underflow if difference does not produced the carry is Negative.....
assign underflow = ~under;

//Checking of overflow 
 output overflow;
 and A0(overflow , diff_new[8] , 1'b1);

//Multiplication of Mantissa...
wire [47:0]proo;
vedic_24 M0(proo , ({1'b1 , A[22:0]}) , ({1'b1 , B[22:0]}));

//Normalization of mantissa to 23 bit...
wire [22:0]mantiss;
wire flgg;
wire dummy_c;
normalize N0(mantiss , flgg , proo);
CLA_8 C8(expo_sum , dummy_c , diff_new[7:0] , {7'b0000000 , flgg} , 1'b0);


//Final answer..
  assign M = {temp , expo_sum , mantiss};
 // gtkwave p.vcd
//iverilog -o nitu halfv.v full.v carry_3.v carry_6.v csa_6.v csa_12.v ved_3.v vedic_6.v vedic_12.v csa_24.v vedic_24.v carry_4.v carry_8.v carry_9.v subs_8.v norm.v project.v project_test.v
endmodule