module fast_to_slow(
    input  logic FAST_clk,     // Fast clock
    input  logic SLOW_clk,     // Slow clock
    input  logic reset,        
    input  logic[11:0] data_in, 
    output logic[11:0] sync_data_out
);

reg [11:0] data_reg[2:0];      // Register array to hold data
reg enable_reg[1:0];           // Enable registers for synchronization

// sync_data_out gets the value from data_reg[1]
assign sync_data_out = data_reg[1];

// Fast clock domain logic
always_ff @(posedge FAST_clk or posedge reset) begin
    if (reset) begin
        data_reg[0] <= 0;      // Reset data
        data_reg[2] <= 0;      
    end else begin
        data_reg[0] <= data_in;   // input data
        if (enable_reg[1]) data_reg[2] <= data_reg[0];   // Transfer data if enabled
    end
end

// Slow clock domain logic
always_ff @(posedge SLOW_clk or posedge reset) begin
    if (reset) begin
        data_reg[1] <= 0;      // Reset data_reg[1]
    end else begin
        data_reg[1] <= data_reg[2];  // Capture data from fast clock domain
    end
end

// Enable signal generation (using double flop synchronization)
always_ff @(negedge FAST_clk or posedge reset) begin
    if (reset) begin
        enable_reg[0] <= 0;   // Reset enable_reg[0]
        enable_reg[1] <= 0;   // Reset enable_reg[1]
    end else begin
        enable_reg[0] <= SLOW_clk;     // Capture slow clock signal
        enable_reg[1] <= enable_reg[0];  // Synchronize enable signal
    end
end

endmodule
