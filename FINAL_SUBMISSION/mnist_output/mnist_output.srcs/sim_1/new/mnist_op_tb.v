`timescale 1ns / 1ps

module testbench;
    reg clk;
    reg [9:0] cnn_output;
    wire [6:0] seg;
    wire [7:0] anode;

    mnist_op uut (
        .clk(clk),
        .cnn_output(cnn_output),
        .seg(seg),
        .anode(anode)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        cnn_output = 10'b0000000000;
        #10;
        cnn_output = 10'b1000000000;
        #10;
        cnn_output = 10'b0100000000;
        #10;
        cnn_output = 10'b0010000000;
        #10;
        cnn_output = 10'b0001000000;
        #10;
        cnn_output = 10'b0000100000;
        #10;
        cnn_output = 10'b0000010000;
        #10;
        cnn_output = 10'b0000001000;
        #10;
        cnn_output = 10'b0000000100;
        #10;
        cnn_output = 10'b0000000010;
        #10;
        cnn_output = 10'b0000000001;
        #10;
        $finish;
    end
endmodule