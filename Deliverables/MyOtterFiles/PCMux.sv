`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 1/12/26 1:42:19 AM
module PCMux(
    input logic [31:0]PCMux_In0,
    input logic [31:0]PCMux_In1,
    input logic [31:0]PCMux_In2,
    input logic [31:0]PCMux_In3,
    input logic [1:0]PCMux_Sel,
    output logic [31:0]PCMux_Out
    );
    
    always_comb begin
        case(PCMux_Sel)
            0: PCMux_Out = PCMux_In0; // select in1
            1: PCMux_Out = PCMux_In1; // select in2
            2: PCMux_Out = PCMux_In2; // select in3
            3: PCMux_Out = PCMux_In3; // select in4
            default: PCMux_Out = 32'hDEADBEEF; // if there is a problem, DEADBEEF will show
        endcase
    end
endmodule
