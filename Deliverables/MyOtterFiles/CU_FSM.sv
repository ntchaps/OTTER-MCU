`timescale 1ns / 1ps
// Nicholas Chapman
// Create Date 2/24/26 1:01:54 PM
module CU_FSM(
input RST, INTR, clk,
input logic [6:0] opcode,
output logic PCWrite, regWrite, memWE2, memRDEN1, memRDEN2, reset
    );
    
    typedef enum {ST_INIT, ST_FETCH, ST_EXEC, ST_WRBACK} STATES;

STATES NS, PS;

    //State Register
    always_ff@(posedge clk) begin
        if (RST) begin
            PS <= ST_INIT;
        end
        else begin
            PS <= NS;
        end
    end
    
    //State Decoder
    always_comb begin
        //Recommend setting all Control Unit FSM outputs to zero
        PCWrite = 0;
        regWrite = 0;
        memWE2 = 0;
        memRDEN1 = 0;
        memRDEN2 = 0;
        reset = 0;
        NS = PS;
        // case statement sensitive to PS changing. Each option of case is a state of the FSM state diagram
        case (PS)
        //Initial State
        ST_INIT: begin
          reset = 1'b1;
          NS = ST_FETCH;
        end 
        //Fetch State
        ST_FETCH: begin
              memRDEN1 = 1;
//              PCWrite = 1;
              NS = ST_EXEC;   // or wait on a real mem_ready input
            end 
        //Execution State
        ST_EXEC: begin
        //Based on an instruction's data path and control signal diagram determines which Control Unit FSM output(s) need to be active, i.e. '1'
        // case statement sensitive to op-code changing. Reason ir [6:0] is a control unit fsm input. Each case option is an op-code of an instruction in the sample program
            case (opcode)
                7'b0110011: begin // Rtype 
                    PCWrite = 1;
                    regWrite = 1;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                7'b0010011: begin // Itype 
                    PCWrite = 1;
                    regWrite = 1;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                7'b0000011: begin // Itype load instructions
                    PCWrite = 1;
                    regWrite = 0;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 1;
                    reset = 0;
                    // NS = ST_WRBACK;
                end
                7'b0100011: begin // Stype
                    PCWrite = 1;
                    regWrite = 0;
                    memWE2 = 1;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                7'b1100011: begin // Btype
                    PCWrite = 1;
                    regWrite = 0;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                7'b0110111: begin // lui
                    PCWrite = 1;
                    regWrite = 1;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                7'b0010111: begin // auipc
                    PCWrite = 1;
                    regWrite = 1;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                7'b1101111: begin // jal
                    PCWrite = 1;
                    regWrite = 1;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                7'b1100111: begin // jalr
                    PCWrite = 1;
                    regWrite = 1;
                    memWE2 = 0;
//                    memRDEN1 = 1;
                    memRDEN2 = 0;
                    reset = 0;
                end
                default: ;
                endcase // case ir
                if (opcode == 7'b0000011) NS = ST_WRBACK;
                else NS = ST_FETCH;
            end
            ST_WRBACK: begin
              PCWrite = 0;
              regWrite = 1;
              memWE2 = 0;
//              memRDEN1 = 1;
              memRDEN2 = 1;
              reset = 0;
              NS = ST_FETCH;   // or wait on a real mem_ready input
            end 
            default: NS = ST_INIT;
            endcase
            end
endmodule