`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 2/1/26 12:34:11 PM
module ALU(
    input logic [31:0] srcA, srcB,
    input logic [3:0] alu_fun,
    output logic [31:0] result
    );
    
    always_comb begin
        case(alu_fun)
            4'b0000 : result = srcA + srcB;     // add
            4'b1000 : result = srcA - srcB;         // sub
            4'b0110 : result = srcA | srcB;     // or
            4'b0111 : result = srcA & srcB;     // and
            4'b0100 : result = srcA ^ srcB;     // xor
            4'b0101 : result = srcA >> srcB[4:0];    // srl
            4'b0001 : result = srcA << srcB[4:0];    // sll
            4'b1101 : result = $signed(srcA) >>> $signed(srcB[4:0]);   // sra
            4'b0010 : result = $signed(srcA) < $signed(srcB);   // slt
            4'b0011 : result = srcA < srcB;     // sltu
            4'b1001 : result = srcA;            // lui-copy
            default: result = 32'hDEADBEEF;     // ERROR MSG
        endcase
    end
endmodule
