module dadda_multiplier_8(
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] product
);

wire [7:0] p0;
wire [7:0] p1;
wire [7:0] p2;
wire [7:0] p3;

dadda_multiplier_4 M0(
    .a(a[3:0]),
    .b(b[3:0]),
    .product(p0)
);

dadda_multiplier_4 M1(
    .a(a[3:0]),
    .b(b[7:4]),
    .product(p1)
);

dadda_multiplier_4 M2(
    .a(a[7:4]),
    .b(b[3:0]),
    .product(p2)
);

dadda_multiplier_4 M3(
    .a(a[7:4]),
    .b(b[7:4]),
    .product(p3)
);

assign product =
      {8'b0,p0}
    + ({8'b0,p1} << 4)
    + ({8'b0,p2} << 4)
    + ({8'b0,p3} << 8);

endmodule