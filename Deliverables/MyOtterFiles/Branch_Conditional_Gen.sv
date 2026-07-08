`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 2/11/26 12:13:07 AM
module Branch_Conditional_Gen(
    input logic [31:0] rs1, rs2,
    output logic br_eq, br_lt, br_ltu
    );
    
    always_comb begin
        br_eq  = (rs1 == rs2);
        br_lt  = ($signed(rs1) < $signed(rs2)); // signed for BLT/BGE
        br_ltu = (rs1 < rs2);                   // unsigned for BLTU/BGEU
    end
    
endmodule
