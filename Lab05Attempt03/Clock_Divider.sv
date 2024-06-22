/*
CLOCK DIVIDER: Outputs a clock signal by dividing an input clock signal according to count_end

INPUTS:
- input clock (clock_in)
- reset signal (reset)
- count end value (count_end)

OUTPUTS:
- output clock (clock_out)
*/

module Clock_Divider(
    input wire clock_in,
    input wire reset,
    input wire [31:0] count_end,
    output reg clock_out
);

    // Register to keep track of the count
    reg [31:0] count = 32'd0;

    // Clock divider logic
    always @(posedge clock_in) begin
        if (reset) begin
            // Reset count and output clock
            count <= 0;
            clock_out <= 0;
        end
        else begin
            if (count < count_end - 1) begin
                // Increment count if not reached count_end
                count <= count + 1;
            end
            else begin
                // Toggle output clock
                clock_out <= ~clock_out;
                // Reset count
                count <= 0;
            end
        end
    end

endmodule