module dadda_multiplier_32_unsigned( 
    input [31:0] a, 
    input [31:0] b, 
    output [63:0] product 
);
wire [31:0] p0; 
wire [31:0] p1; 
wire [31:0] p2; 
wire [31:0] p3;

dadda_multiplier_16 M0( 
    .a(a[15:0]), 
    .b(b[15:0]), 
    .product(p0) 
);
dadda_multiplier_16 M1( 
    .a(a[15:0]), 
    .b(b[31:16]), 
    .product(p1) 
); 
dadda_multiplier_16 M2( 
    .a(a[31:16]), 
    .b(b[15:0]), 
    .product(p2) 
); 
dadda_multiplier_16 M3( 
    .a(a[31:16]), 
    .b(b[31:16]), 
    .product(p3) 
);
assign product = 
    {32'b0,p0} 
    + ({32'b0,p1} << 16) 
    + ({32'b0,p2} << 16) 
    + ({32'b0,p3} << 32); 
endmodule
