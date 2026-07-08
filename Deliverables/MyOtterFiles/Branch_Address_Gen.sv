`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 2/10/26 11:59:23 PM
module Branch_Address_Gen(
    input logic [31:0] PC, Jtype, Btype, Itype, rs1,
    output logic [31:0] jal, branch, jalr
    );
    
    assign jal = PC + Jtype;
    assign branch = PC + Btype;
    assign jalr = rs1 + Itype & 32'hFFFF_FFFE;
    
endmodule
