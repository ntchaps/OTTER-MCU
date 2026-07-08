`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 2/1/26 10:37:40 PM
module IMM_GEN(
    input logic [31:7] ir,
    output logic [31:0] Utype, Itype, Stype, Btype, Jtype
    );
    
    assign Utype = {ir[31:12],{12{1'b0}}};
    assign Itype = {{20{ir[31]}}, ir[31:20]};
    assign Stype = {{20{ir[31]}}, ir[31:25], ir[11:7]};
    assign Btype = {{19{ir[31]}}, ir[31], ir[7], ir[30:25], ir[11:8], 1'b0};
    assign Jtype = {{11{ir[31]}}, ir[31], ir[19:12], ir[20], ir[30:21], 1'b0};
    
endmodule

