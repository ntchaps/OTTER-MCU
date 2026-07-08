`timescale 1ns / 1ps
// Nicholas Chapman 3/3/26
module Mux(
    input logic [31:0]Mux_In0,
    input logic [31:0]Mux_In1,
    input logic Mux_Sel,
    output logic [31:0]Mux_Out
    );
    
    always_comb begin
        case(Mux_Sel)
            0: Mux_Out = Mux_In0; // select in1
            1: Mux_Out = Mux_In1; // select in2
            default: Mux_Out = 32'hDEADBEEF; // if there is a problem, DEADBEEF will show
        endcase
    end
endmodule
