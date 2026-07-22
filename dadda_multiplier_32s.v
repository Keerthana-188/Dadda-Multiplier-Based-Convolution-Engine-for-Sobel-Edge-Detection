`timescale 1ns / 1ps

module dadda_multiplier_32(

    input  signed [31:0] a,
    input  signed [31:0] b,
    output signed [63:0] product

);

wire sign;

wire [31:0] abs_a;
wire [31:0] abs_b;

wire [63:0] unsigned_product;

assign sign = a[31] ^ b[31];

assign abs_a = a[31] ? (~a + 32'd1) : a;
assign abs_b = b[31] ? (~b + 32'd1) : b;

dadda_multiplier_32_unsigned U0(

    .a(abs_a),
    .b(abs_b),
    .product(unsigned_product)

);

assign product =
        sign ? (~unsigned_product + 64'd1)
             : unsigned_product;

endmodule
