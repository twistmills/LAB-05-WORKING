module Modulation_Selector(

    input clk, 
    input [4:0]LFSR_output,
    input [1:0] modulation_selector,
    
    input [11:0] sin,
    
    output logic [11:0] modulated_signal,
    
    output [1:0] debug_state

); 

localparam ASK  = 2'b00;
localparam FSK  = 2'b01;
localparam BPSK = 2'b10;
localparam LFSR = 2'b11;

reg [1:0] state;

assign debug_state = state;

always_ff @(posedge clk) begin
    case(state)
    
        ASK: begin
            if(modulation_selector == ASK) state <= ASK; 
            else if(modulation_selector == FSK) state <= FSK; 
            else if(modulation_selector == BPSK) state <= BPSK; 
            else if(modulation_selector == LFSR) state <= LFSR; 
            
            // Get correct ASK modulated signal based on LFSR_output
            case (LFSR_output[0])
                1'b0 : modulated_signal = 12'b0;
                1'b1 : modulated_signal = sin;
                default: modulated_signal = 12'b0;
            endcase
        end
        
        FSK: begin
            if(modulation_selector == ASK) state <= ASK; 
            else if(modulation_selector == FSK) state <= FSK; 
            else if(modulation_selector == BPSK) state <= BPSK; 
            else if(modulation_selector == LFSR) state <= LFSR;
            
            modulated_signal = sin;
            
        end
        
        BPSK: begin
            if(modulation_selector == ASK) state <= ASK; 
            else if(modulation_selector == FSK) state <= FSK; 
            else if(modulation_selector == BPSK) state <= BPSK; 
            else if(modulation_selector == LFSR) state <= LFSR;

            // Get correct modulated signal based on LFSR_output
            case (LFSR_output[0])
                1'b0 : modulated_signal = ~sin;
                1'b1 : modulated_signal = sin;
                default: modulated_signal = 12'b0;
            endcase 
        end
        
        LFSR: begin
            if(modulation_selector == ASK) state <= ASK; 
            else if(modulation_selector == FSK) state <= FSK; 
            else if(modulation_selector == BPSK) state <= BPSK; 
            else if(modulation_selector == LFSR) state <= LFSR;
            
            // Get correct modulated signal based on LFSR_output
            case (LFSR_output[0])
                1'b0 : modulated_signal = 12'b1000_0000_0000;
                1'b1 : modulated_signal = 12'b0;
                default: modulated_signal = 12'b0;
            endcase
        end
        
    endcase
end

endmodule
