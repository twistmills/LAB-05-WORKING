module LFSR_5_bit(
    input clk,                     // Clock input
    input reset,                   // Reset input
    output reg [4:0] LFSR_output   //5-bit output
);
	

	// Seed LFRS with non zero value
	 initial begin
		LFSR_output = 5'b0_0001; 
	 end
	 
	 
    // XOR_Tap wire, XOR of bit 0 and bit 2 of the current output
    wire XOR_Tap;
    assign XOR_Tap = LFSR_output[0] ^ LFSR_output[2];
	 
    always @(posedge clk) begin
        if (reset) begin
            LFSR_output <= 5'b0_0001; 
        end
        else begin
            // Shift left and insert XOR_Tap at bit 0
            LFSR_output <= {XOR_Tap, LFSR_output[4:1]};
        end
    end

endmodule