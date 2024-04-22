`timescale 1ns / 1ps

module mnist_op(
    input clk,
    input [9:0] cnn_output,
    output reg [6:0] seg,
    output reg [7:0] anode
);

reg [3:0] output_digit;

always @* begin
    case(cnn_output)
        10'b0000000000: output_digit = 4'b0000; // Map CNN output 0 to digit 0
        10'b1000000000: output_digit = 4'b0001; // Map CNN output 1 to digit 1
        10'b0100000000: output_digit = 4'b0010; // Map CNN output 2 to digit 2
        10'b0010000000: output_digit = 4'b0011; // Map CNN output 3 to digit 3
        10'b0001000000: output_digit = 4'b0100; // Map CNN output 4 to digit 4
        10'b0000100000: output_digit = 4'b0101; // Map CNN output 5 to digit 5
        10'b0000010000: output_digit = 4'b0110; // Map CNN output 6 to digit 6
        10'b0000001000: output_digit = 4'b0111; // Map CNN output 7 to digit 7
        10'b0000000100: output_digit = 4'b1000; // Map CNN output 8 to digit 8
        10'b0000000010: output_digit = 4'b1001; // Map CNN output 9 to digit 9
        default: output_digit = 4'b1111; // Invalid digit, turn off all segments
    endcase
end

always @* begin
    case(output_digit)
        4'b0000: seg = 7'b1000000; // Digit 0
        4'b0001: seg = 7'b1111001; // Digit 1
        4'b0010: seg = 7'b0100100; // Digit 2
        4'b0011: seg = 7'b0110000; // Digit 3
        4'b0100: seg = 7'b0011001; // Digit 4
        4'b0101: seg = 7'b0010010; // Digit 5
        4'b0110: seg = 7'b0000010; // Digit 6
        4'b0111: seg = 7'b1111000; // Digit 7
        4'b1000: seg = 7'b0000000; // Digit 8
        4'b1001: seg = 7'b0000100; // Digit 9
        default: seg = 7'b1111111; // Default: Turn off all segments
    endcase
end

// Anode control
initial begin
anode = 8'b11111110; // All anodes are turned on except the one
end

endmodule