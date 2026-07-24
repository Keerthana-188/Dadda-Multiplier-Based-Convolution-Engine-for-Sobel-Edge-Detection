`timescale 1ns / 1ps
module dadda_multiplier_16(
    input  [15:0] a,
    input  [15:0] b,
    output [31:0] product
);

wire [15:0] p0;
wire [15:0] p1;
wire [15:0] p2;
wire [15:0] p3;

dadda_multiplier_8 M0(
    .a(a[7:0]),
    .b(b[7:0]),
    .product(p0)
);

dadda_multiplier_8 M1(
    .a(a[7:0]),
    .b(b[15:8]),
    .product(p1)
);

dadda_multiplier_8 M2(
    .a(a[15:8]),
    .b(b[7:0]),
    .product(p2)
);

dadda_multiplier_8 M3(
    .a(a[15:8]),
    .b(b[15:8]),
    .product(p3)
);

assign product =
      {16'b0,p0}
    + ({16'b0,p1} << 8)
    + ({16'b0,p2} << 8)
    + ({16'b0,p3} << 16);

endmodule
