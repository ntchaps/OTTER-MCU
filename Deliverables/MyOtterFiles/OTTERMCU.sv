`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 3/3/26 11:51:23 AM
module OTTERMCU(
    input logic RST, INTR, clk,
    input logic [31:0]IOBUS_IN,
    output logic IOBUS_WR,
    output logic [31:0] IOBUS_OUT, IOBUS_ADDR
    );
    
    logic [31:0] PC, PC_DIN, ir, CSR_reg, DOUT2, result, srcA, srcB, Itype, Btype, Jtype, 
    Stype, Utype, rs1, rs2, jalr, branch, jal, reg_wd;
    logic [1:0] alu_srcB, pcSource, rf_wr_sel;
    logic [3:0] alu_fun;
    logic memRDEN1, memRDEN2, memWE2;
    logic PCWrite, regWrite, reset;
    logic alu_srcA;
    logic br_eq, br_lt, br_ltu;
    
    // MEMORY
    Memory MEM(
        .MEM_CLK(clk),         // clk
        .MEM_RDEN1(memRDEN1),       // read enable Instruction
        .MEM_RDEN2(memRDEN2),       // read enable data
        .MEM_WE2(memWE2),         // write enable.
        .MEM_ADDR1(PC[15:2]),       // Instruction Memory word Addr (Connect to PC[15:2])
        .MEM_ADDR2(result),       // Data Memory Addr
        .MEM_DIN2(rs2),        // Data to save
        .MEM_SIZE(ir[13:12]),        // 0-Byte, 1-Half, 2-Word
        .MEM_SIGN(ir[14]),        // 1-unsigned 0-signed
        .IO_IN(IOBUS_IN),           // Data from IO
        .IO_WR(IOBUS_WR),           // IO 1-write 0-read
        .MEM_DOUT1(ir),       // Instruction
        .MEM_DOUT2(DOUT2)        // Data
    ); 
    
    assign CSR_reg = 0;
    
    // REG MUX
    PCMux REG_Mux (
        .PCMux_In0(PC+4),
        .PCMux_In1(CSR_reg),
        .PCMux_In2(DOUT2),
        .PCMux_In3(result),
        .PCMux_Sel(rf_wr_sel),
        .PCMux_Out(reg_wd)
    );
    
    // PROGRAM COUNTER
    PC program_counter(
        .clk(clk),
        .PC_RST(reset),
        .PC_EN(PCWrite),
        .PC_DIN(PC_DIN),
        .PC_Out(PC)
    );
    
    PCMux program_counter_mux(
        .PCMux_In0(PC+4),
        .PCMux_In1(jalr),
        .PCMux_In2(branch),
        .PCMux_In3(jal),
        .PCMux_Sel(pcSource),
        .PCMux_Out(PC_DIN)
    );
    
    // REG FILE
    assign IOBUS_OUT = rs2;
    REG_FILE reg_file_module(
        .clk(clk),
        .en(regWrite),
        .adr1(ir[19:15]),
        .adr2(ir[24:20]),
        .wa(ir[11:7]),
        .wd(reg_wd),
        .rs1(rs1),
        .rs2(rs2)
    );
    
    // ALU
    assign IOBUS_ADDR = result;
    ALU alu_module (
        .srcA(srcA),
        .srcB(srcB),
        .alu_fun(alu_fun),
        .result(result)
    );
    
    // ALU srcA MUX
    Mux ALU_srcA_MUX (
        .Mux_In0(rs1),
        .Mux_In1(Utype),
        .Mux_Sel(alu_srcA),
        .Mux_Out(srcA)
    );
    
    // ALU srcB MUX
    PCMux ALU_srcB_Mux (
        .PCMux_In0(rs2),
        .PCMux_In1(Itype),
        .PCMux_In2(Stype),
        .PCMux_In3(PC),
        .PCMux_Sel(alu_srcB),
        .PCMux_Out(srcB)
    );
    
    // IMMEDIATE GENERATOR
    IMM_GEN immediate_generator (
        .ir(ir[31:7]),
        .Utype(Utype),
        .Itype(Itype),
        .Stype(Stype),
        .Btype(Btype),
        .Jtype(Jtype)  
    );
    
    // BRANCH CONDITIONAL GENERATOR
    Branch_Conditional_Gen Branch_Cond_Gen(
        .rs1(rs1),
        .rs2(rs2),
        .br_eq(br_eq),
        .br_lt(br_lt),
        .br_ltu(br_ltu)
    );
    
    // CONTROL UNIT DECODER
    CU_DCDR control_unit_decoder(
        .ir(ir),
        .br_eq(br_eq),
        .br_lt(br_lt),
        .br_ltu(br_ltu),
        .alu_fun(alu_fun),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB),
        .pc_Source(pcSource),
        .rf_wr_sel(rf_wr_sel)
    );
    
    // CONTROL UNIT FSM
    CU_FSM control_unit_fsm(
        .RST(RST),
        .INTR(INTR),
        .clk(clk),
        .opcode(ir[6:0]),
        .PCWrite(PCWrite),
        .regWrite(regWrite),
        .memWE2(memWE2),
        .memRDEN1(memRDEN1),
        .memRDEN2(memRDEN2),
        .reset(reset)
    );
    
    Branch_Address_Gen branch_addr_gen (
        .PC(PC),
        .Jtype(Jtype),
        .Btype(Btype),
        .Itype(Itype),
        .rs1(rs1),
        .jal(jal), 
        .branch(branch),
        .jalr(jalr)
    );
endmodule
