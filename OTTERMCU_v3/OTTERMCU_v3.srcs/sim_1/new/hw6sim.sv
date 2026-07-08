`timescale 1ns/1ps
module OTTERMCUsim;
  logic RST, INTR, clk;
  logic [31:0] IOBUS_IN;
  logic IOBUS_WR;
  logic [31:0] IOBUS_OUT, IOBUS_ADDR;

  // DUT (match the module name!)
  OTTERMCU UUT (
    .RST(RST), .INTR(INTR), .clk(clk),
    .IOBUS_IN(IOBUS_IN), .IOBUS_WR(IOBUS_WR),
    .IOBUS_OUT(IOBUS_OUT), .IOBUS_ADDR(IOBUS_ADDR)
  );
  
  // clock
  always begin
   #10 clk = ~clk;
  
  #60 
  RST = 1'b0;
  IOBUS_IN = 32'h2;
  end
  // init values
  initial begin
    clk = 1'b0;
  end

endmodule