`timescale 1ns / 1ps

module conv_pixel;

//////////////////////////////////////////////////////////
// MEMORY
//////////////////////////////////////////////////////////

reg signed [31:0] mem [0:5000];

integer outfile;

integer row;
integer col;

reg signed [31:0] p0,p1,p2;
reg signed [31:0] p3,p4,p5;
reg signed [31:0] p6,p7,p8;

wire signed [31:0] k0,k1,k2;
wire signed [31:0] k3,k4,k5;
wire signed [31:0] k6,k7,k8;

assign k0 = mem[1024];
assign k1 = mem[1025];
assign k2 = mem[1026];

assign k3 = mem[1027];
assign k4 = mem[1028];
assign k5 = mem[1029];

assign k6 = mem[1030];
assign k7 = mem[1031];
assign k8 = mem[1032];

//////////////////////////////////////////////////////////
// DADDA MULTIPLIER CHAIN
//////////////////////////////////////////////////////////

wire signed [63:0] m0_prod;
wire signed [63:0] m1_prod;
wire signed [63:0] m2_prod;
wire signed [63:0] m3_prod;
wire signed [63:0] m4_prod;
wire signed [63:0] m5_prod;
wire signed [63:0] m6_prod;
wire signed [63:0] m7_prod;
wire signed [63:0] m8_prod;

wire signed [31:0] s1,s2,s3,s4,s5,s6,s7,s8;
wire signed [31:0] conv_result;

dadda_multiplier_32 D0(.a(p0), .b(k0), .product(m0_prod));
dadda_multiplier_32 D1(.a(p1), .b(k1), .product(m1_prod));
dadda_multiplier_32 D2(.a(p2), .b(k2), .product(m2_prod));
dadda_multiplier_32 D3(.a(p3), .b(k3), .product(m3_prod));
dadda_multiplier_32 D4(.a(p4), .b(k4), .product(m4_prod));
dadda_multiplier_32 D5(.a(p5), .b(k5), .product(m5_prod));
dadda_multiplier_32 D6(.a(p6), .b(k6), .product(m6_prod));
dadda_multiplier_32 D7(.a(p7), .b(k7), .product(m7_prod));
dadda_multiplier_32 D8(.a(p8), .b(k8), .product(m8_prod));

assign s1 = m0_prod[31:0];
assign s2 = s1 + m1_prod[31:0];
assign s3 = s2 + m2_prod[31:0];
assign s4 = s3 + m3_prod[31:0];
assign s5 = s4 + m4_prod[31:0];
assign s6 = s5 + m5_prod[31:0];
assign s7 = s6 + m6_prod[31:0];
assign s8 = s7 + m7_prod[31:0];

assign conv_result = s8 + m8_prod[31:0];

//////////////////////////////////////////////////////////
// OUTPUT PIXEL
//////////////////////////////////////////////////////////

integer blur_pixel;

//////////////////////////////////////////////////////////
// MAIN
//////////////////////////////////////////////////////////

initial
begin

    $readmemh("image_32.mem", mem);
$display("Pixel0    = %d", mem[0]);
$display("Pixel1    = %d", mem[1]);
$display("Pixel1023 = %d", mem[1023]);

$display("Kernel0 = %d", mem[1024]);
$display("Kernel1 = %d", mem[1025]);
$display("Kernel2 = %d", mem[1026]);

    outfile = $fopen("DOG_y_32.mem","w");
    if(outfile == 0)
begin
    $display("ERROR: Cannot open output file!");
    $finish;
end
else
    $display("Output file opened successfully.");

    for(row=0; row<30; row=row+1)
    begin
        for(col=0; col<30; col=col+1)
        begin
        if(row==0 && col==0)
            $display("Loop started");

            p0 = mem[(row*32)+col];
            p1 = mem[(row*32)+col+1];
            p2 = mem[(row*32)+col+2];

            p3 = mem[((row+1)*32)+col];
            p4 = mem[((row+1)*32)+col+1];
            p5 = mem[((row+1)*32)+col+2];

            p6 = mem[((row+2)*32)+col];
            p7 = mem[((row+2)*32)+col+1];
            p8 = mem[((row+2)*32)+col+2];

            #10;
            //////////////////////////////////////////////////////////
// DEBUG WINDOW (Center of Image)
//////////////////////////////////////////////////////////

if(row==15 && col==15)
begin
    $display("==========================================");
    $display("DEBUG WINDOW @ row=%0d col=%0d",row,col);

    $display("p0=%0d  p1=%0d  p2=%0d",p0,p1,p2);
    $display("p3=%0d  p4=%0d  p5=%0d",p3,p4,p5);
    $display("p6=%0d  p7=%0d  p8=%0d",p6,p7,p8);

    $display("");

    $display("k0=%0d  k1=%0d  k2=%0d",k0,k1,k2);
    $display("k3=%0d  k4=%0d  k5=%0d",k3,k4,k5);
    $display("k6=%0d  k7=%0d  k8=%0d",k6,k7,k8);

    $display("");

    $display("conv_result = %0d",conv_result);

    if(conv_result < 0)
        $display("abs(conv) = %0d",-conv_result);
    else
        $display("abs(conv) = %0d",conv_result);

    $display("==========================================");
end

           // Absolute value for edge magnitude

if(conv_result < 0)
    blur_pixel = -conv_result;
else
    blur_pixel = conv_result;


// Clamp

if(blur_pixel > 255)
    blur_pixel = 255;

            $fdisplay(outfile,"%02h", blur_pixel[7:0]);

        end
    end

    $fclose(outfile);

    $display("--------------------------------");
    $display("CNN COMPLETE");
    $display("output_image.mem generated");
    $display("--------------------------------");

    $finish;

end

endmodule