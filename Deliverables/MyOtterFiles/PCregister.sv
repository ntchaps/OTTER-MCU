`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 1/13/26 7:43:29 PM
module PC(
    input clk,
    input PC_RST, 
    input PC_EN,
    input logic [31:0]PC_DIN,
    output logic [31:0]PC_Out
    );
    always_ff @(posedge clk) begin
        if(PC_RST)
            PC_Out <= 0;
        else if (PC_EN)
            PC_Out <= PC_DIN;
        //no else, creates memory (latch)
        end
endmodule
