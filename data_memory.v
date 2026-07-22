`timescale 1ns / 1ps

module data_memory(

    input clk,
    input rst,

    input [12:0] wr_addr,
    input [31:0] wr_data,

    input sw,

    input [12:0] rd_addr,

    output [31:0] data_out

);

//////////////////////////////////////////////////////////
// DATA MEMORY
//////////////////////////////////////////////////////////

reg [31:0] data_mem [0:8191];

integer i;

//////////////////////////////////////////////////////////
// LOAD IMAGE FROM FILE
//////////////////////////////////////////////////////////

initial begin

    $readmemh("image_32.mem", data_mem);

    #1;

    $display("Pixel0   = %h", data_mem[0]);
    $display("Pixel1   = %h", data_mem[1]);
    $display("Pixel2   = %h", data_mem[2]);

    $display("Pixel32  = %h", data_mem[32]);
    $display("Pixel33  = %h", data_mem[33]);
    $display("Pixel34  = %h", data_mem[34]);

    $display("Pixel64  = %h", data_mem[64]);
    $display("Pixel65  = %h", data_mem[65]);
    $display("Pixel66  = %h", data_mem[66]);

    // Kernel values

    $display("K0 = %h", data_mem[1024]);
    $display("K1 = %h", data_mem[1025]);
    $display("K2 = %h", data_mem[1026]);
    $display("K3 = %h", data_mem[1027]);
    $display("K4 = %h", data_mem[1028]);
    $display("K5 = %h", data_mem[1029]);
    $display("K6 = %h", data_mem[1030]);
    $display("K7 = %h", data_mem[1031]);
    $display("K8 = %h", data_mem[1032]);

end

//////////////////////////////////////////////////////////
// WRITE LOGIC
//////////////////////////////////////////////////////////

always @(posedge clk)
begin

    //////////////////////////////////////////////////////
    // RESET
    //////////////////////////////////////////////////////

    if(rst)
    begin

        // Optional: clear memory on reset

        for(i=0;i<8192;i=i+1)
            data_mem[i] <= data_mem[i];

    end

    //////////////////////////////////////////////////////
    // STORE
    //////////////////////////////////////////////////////

    else if(sw)
    begin

        data_mem[wr_addr] <= wr_data;

    end

end

//////////////////////////////////////////////////////////
// ASYNCHRONOUS READ
//////////////////////////////////////////////////////////

assign data_out = data_mem[rd_addr];

endmodule