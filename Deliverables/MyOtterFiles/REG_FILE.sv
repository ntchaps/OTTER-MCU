`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 1/20/26 10:23:57 PM
module REG_FILE(
    input clk, en,
    input logic [4:0] adr1, adr2, wa,
    input [31:0] wd,
    output logic [31:0] rs1, rs2
    );
    
    logic [31:0] ram [31:0];        // create the array of addresses and data at each
    initial begin                   // create a loop that fills each bit of every address with a 0
        automatic int i = 0;
        for (i=0; i<32; i++)begin
            ram[i] = 0;
        end
    end                             // loop end
    always_ff@(posedge clk) begin
        if (en && (wa != 0)) begin  // if enable is high and address 0 is not chosen to right to
            ram[wa] <= wd;          // fill the write address with the write data
        end
    end
    
assign rs1 = ram[adr1];             // always assign register 1 to the data at address 1
assign rs2 = ram[adr2];             // always assign register 2 to the data at address 2
endmodule
