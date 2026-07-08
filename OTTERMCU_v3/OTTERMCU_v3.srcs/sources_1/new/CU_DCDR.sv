`timescale 1ns / 1ps
// Nicholas Chapman 2/24/26
module CU_DCDR(
    input logic [31:0] ir,
    input logic br_eq, br_lt, br_ltu,
    output logic [3:0] alu_fun,
    output logic alu_srcA,
    output logic [1:0] alu_srcB, pc_Source, rf_wr_sel
    );
    
    always_comb begin
        pc_Source = 2'b00;
        alu_srcA  = 1'b0;
        alu_srcB  = 2'b00;
        rf_wr_sel = 2'b00;
        alu_fun   = 4'b0000;
        case (ir[6:0])
        ///// R-type /////
            7'b0110011: begin 
                pc_Source = 2'b00;
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                rf_wr_sel = 2'b11;
                case(ir[30]) // bit 30
                    1'b0: begin
                    case(ir[14:12]) // funct3
                        3'b000: alu_fun = 4'b0000; // add
                        3'b110: alu_fun = 4'b0110; // or
                        3'b111: alu_fun = 4'b0111; // and
                        3'b100: alu_fun = 4'b0100; // xor 
                        3'b101: alu_fun = 4'b0101; // srl
                        3'b001: alu_fun = 4'b0001; // sll
                        3'b010: alu_fun = 4'b0010; // slt
                        3'b011: alu_fun = 4'b0011; // sltu
                        default: alu_fun = 4'b0000;
                    endcase // funct3
                    end
                    1'b1: begin
                        case(ir[14:12]) // funct3
                            3'b000: alu_fun = 4'b1000; // sub
                            3'b101: alu_fun = 4'b1101; // sra
                        endcase // funct3
                        end // 1'b1
                   endcase // ir[30]
                end // Rtype opcodes
                 
           ///// I-type /////
           7'b0010011: begin 
                pc_Source = 2'b00;
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                rf_wr_sel = 2'b11;
                    case(ir[14:12]) // funct3
                        3'b000: alu_fun = 4'b0000; // addi
                        3'b110: alu_fun = 4'b0110; // ori
                        3'b111: alu_fun = 4'b0111; // andi
                        3'b100: alu_fun = 4'b0100; // xori
                        3'b001: alu_fun = 4'b0001; // slli
                        3'b010: alu_fun = 4'b0010; // slti
                        3'b011: alu_fun = 4'b0011; // sltui
                        default: begin
                            case(ir[30]) // funct3 101, ir[30] check if 0 or not
                                1'b0: alu_fun = 4'b0101; // srli
                                1'b1: alu_fun = 4'b1101; // srai
                            endcase // ir[30]
                        end // default
                    endcase // funct3
                end // I-type 0010011 opcodes
                
          7'b1100111: begin // I-type 1100111 opcode (jalr)
                pc_Source = 2'b01;
                alu_srcA = 1'b0;    
                alu_srcB = 2'b01;  
                rf_wr_sel = 2'b00;  
                alu_fun = 4'b0000;
          end // I-type 0010011 opcodes (jalr)
          
          7'b0000011: begin // I-type 1100111 opcodes (load instructions)
                pc_Source = 2'b00;  
                alu_srcA = 1'b0;
                alu_srcB = 2'b01;
                rf_wr_sel = 2'b10;
                alu_fun = 4'b0000;
                end // I-type 0000011 opcodes
                
          ////// S-type /////             
          7'b0100011: begin
                pc_Source = 2'b00;  
                alu_srcA = 1'b0;
                alu_srcB = 2'b10;
                rf_wr_sel = 2'b10;
                alu_fun = 4'b0000;
          end // S-type         
                
          ////// B-type /////             
          7'b1100011: begin
                pc_Source = 2'b10;
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                rf_wr_sel = 2'b00;
                alu_fun = 4'b0000;
                case (ir[14:12])
                    3'b000: begin   // beq
                        if(br_eq) pc_Source = 2'b10;
                        else      pc_Source = 2'b00;
                    end
                    3'b101: begin   // bge
                        if (!br_lt) pc_Source = 2'b10;
                        else      pc_Source = 2'b00;
                    end
                    3'b111: begin   // bgeu
                        if(!br_ltu) pc_Source = 2'b10;
                        else      pc_Source = 2'b00;
                    end
                    3'b100: begin   // blt
                        if(br_lt) pc_Source = 2'b10;
                        else      pc_Source = 2'b00;
                    end
                    3'b110: begin   // bltu
                        if(br_ltu) pc_Source = 2'b10;
                        else      pc_Source = 2'b00;
                    end
                    3'b001: begin   // bne
                        if(!br_eq) pc_Source = 2'b10;
                        else      pc_Source = 2'b00;
                    end
                endcase // funct3
          end // B-type   
        
        // LUI
        7'b0110111: begin
                pc_Source = 2'b00;
                alu_srcA = 1'b1;
                alu_srcB = 2'b00;
                rf_wr_sel = 2'b11;
                alu_fun = 4'b1001;
            end
        // AUIPC
        7'b0010111: begin
                pc_Source = 2'b00;
                alu_srcA = 1'b1;
                alu_srcB = 2'b11;
                rf_wr_sel = 2'b11;
                alu_fun = 4'b0000;
            end
        // JAL
        7'b1101111: begin
                pc_Source = 2'b11;
                alu_srcA = 1'b0;
                alu_srcB = 2'b00;
                rf_wr_sel = 2'b00;
                alu_fun = 4'b0000;
            end
        default: ;
        endcase // ir[6:0]
        end // always_comb
endmodule