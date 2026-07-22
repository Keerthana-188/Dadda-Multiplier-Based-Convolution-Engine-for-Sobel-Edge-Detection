`timescale 1ns / 1ps
module dadda_multiplier_4(
    input [3:0] a,
    input [3:0] b,
    output [7:0] product
);

wire [3:0] p0,p1,p2,p3;

dadda_multiplier_2 M0(
    .a(a[1:0]),
    .b(b[1:0]),
    .product(p0)
);

dadda_multiplier_2 M1(
    .a(a[1:0]),
    .b(b[3:2]),
    .product(p1)
);

dadda_multiplier_2 M2(
    .a(a[3:2]),
    .b(b[1:0]),
    .product(p2)
);

dadda_multiplier_2 M3(
    .a(a[3:2]),
    .b(b[3:2]),
    .product(p3)
);

assign product =
      p0
    + (p1 << 2)
    + (p2 << 2)
    + (p3 << 4);

endmodule
