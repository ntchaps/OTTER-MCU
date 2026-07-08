`timescale 1ns/1ps
module OTTERMCUwrappersim;
  logic CLK, BTNC;          // input
  logic [15:0] SWITCHES;    // input
  logic [15:0] LEDS;        // output
  logic [7:0] CATHODES;     // output
  logic [3:0] ANODES;       // output

  // clock
  always #10 CLK = ~CLK;

  // DUT (match the module name!)
  OTTER_Wrapper UUT (
    .CLK(CLK), .BTNC(BTNC), .SWITCHES(SWITCHES), .LEDS(LEDS), .CATHODES(CATHODES), .ANODES(ANODES)
  );
  
  // init values
  initial begin
    CLK = 1'b0;
    BTNC = 1'b1;
    SWITCHES = 15'h2;
    #50;
    BTNC = 1'b0;
    #5000;                 // stop sim
  end

endmodule