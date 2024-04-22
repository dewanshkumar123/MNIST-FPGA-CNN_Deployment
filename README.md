# ES204 Digital Systems
# Week 1 Assignment Project Report
# Indian Institute of Technology, Gandhinagar
# March 15, 2024

## Group Members:-
Sushant Gudmewar (22110264),
John Twipraham Debbarma (22110108),
Parag Sarvoday (22110179) &
Dewansh Kumar (22110071)


	Below are the requirements and tasks done for Week 1.
	
### (a) Problem objective: Deployment of a trained 3-D CNN model on FPGA for image classification of the MNIST dataset.


### (b) Description of the different modules: 
UART: Field-programmable gate arrays (FPGAs) typically incorporate the Universal Asynchronous Receiver Transmitter (UART) as a basic communication interface to enable serial data transfer between the FPGA and external devices. Because of its asynchronous operation, data can be sent between the transmitter and receiver without requiring a common clock signal. A receiver module that transforms incoming serial data back into parallel form and a transmitter module that transforms parallel data into serial format for transmission are the usual components of a UART. Because of its simplicity, variety, and ease of implementation in FPGA-based systems, this serial communication protocol is widely used in many different applications, such as interfacing with wireless modules, sensors, and other peripherals.

BRAM: Field-Programmable Gate Arrays (FPGAs) rely on Block RAM (BRAM), sometimes referred to as memory blocks or just RAM blocks, as a crucial part that offers on-chip memory storage for program code and data storage. BRAMs are programmable memory blocks that designers can instantiate and use to include different memory topologies into their FPGA systems. Single-port and dual-port variants are commonly offered by BRAMs, enabling simultaneous read and write operations from various clock domains. They are frequently used to implement lookup tables with higher storage requirements, cache memory, FIFOs (First-In, First-Out) queues, and data buffers.


### (c) Weekly plan: 
Week 1: Establish the UART communication between the system and the FPGA and ensure the read-write in BRAM. 
Week 2: Provided the trained model for the MNIST dataset classification (Note that images in the MNIST dataset are 28x28 in size) having the following layers and parameters: 
a. Convolutional layer (32 3x3 filters) with ReLU activation [Input Size: 28x28; Output Size: 26x26x32] 
b. AveragePooling Layer (2x2 filter) [Input Size: 26x26x32; Output Size: 13x13x32] c. Fully Connected Layer (64 neurons) [Size after flattening: 5408; Output Size: 64] d. Output Layer (10 classes for MNIST),
The group is expected to first code up the network in Python (NOT Pytorch).
Week 3: Once the Python code is verified, you can start writing the Verilog code. Note that you will be performing systolic array-based matrix multiplication. 
Week 4: You can deploy the trained model for inference on FPGA. Your final goal would be image classification for the MNIST dataset.


### (d) Week-1 update (all the Verilog codes, python codes, etc and a video or PPTs): 
Verilog codes: 

	`timescale 1ns / 1ps
	
	module test(
	    input clk,
	    input read,
	    input write,
	    input reset,
	    input enable,
	    input [3:0]din,
	    output reg clk_out,
	    output reg [3:0]dout2
	    );
	    
	   reg [3:0]add_w=0;
	   reg [3:0]add_r=0;
	   reg [3:0]add_next1,add_next2;
	   wire [3:0] dout;
	  
	clock_divider I10 (clk, slow_clk );
	   
	blk_mem_gen_0 your_instance_name (
	  .clka(slow_clk),    // input wire clka
	  .ena(enable),      // input wire ena
	  .wea(write),      // input wire [0 : 0] wea
	  .addra(add_w),  // input wire [3 : 0] addra
	  .dina(din),    // input wire [3 : 0] dina
	  .clkb(slow_clk),    // input wire clkb
	  .enb(read),      // input wire enb
	  .addrb(add_r),  // input wire [3 : 0] addrb
	  .doutb(dout)  // output wire [3 : 0] doutb
	);
	
	
	always@(posedge slow_clk)
	begin
	    add_r<=add_next1;
	    add_w<=add_next2;
	end
	  
	  //write operation
	always@(*)
	    begin
	    if (reset)
	        add_next2<=0;
	    else if (write)
	        begin
	        if (add_next2==4'b1111)
	            add_next2=add_w;
	        else
	            add_next2=add_w+1;
	         end
	    else
	        add_next2=add_next2;
	    end
	    
	    
	 always@(*)
	    begin
	    if (reset)
	        add_next1<=0;
	    else if (read)
	        begin
	        if (add_next1==4'b1111)
	            add_next1=add_r;
	        else
	            add_next1=add_r+1;
	        end
	    else
	        add_next1=add_next1;
	    end
	   
	always@(*)
	begin
	        dout2=dout;
	        clk_out=slow_clk;
	//        sum=din+dout;
	end
	endmodule
	
	
	module clock_divider(input main_clk, output slow_clk );
	reg [31:0] counter;
	always@ (posedge main_clk)
	begin
	counter <= counter + 1;
	end
	assign slow_clk = counter[27];
	endmodule



Testbench: 

	`timescale 1ns / 1ps
	
	
	module test_tb();
	
	reg clk;
	reg read,write,reset,enable;
	reg [3:0]din;
	wire [3:0]dout;
	wire clk_out;
	test uut(clk,read,write,reset,enable,din,clk_out,dout);
	
	initial
	begin
	clk=0;
	forever #5 clk=~clk;
	end
	
	
	initial begin
	
	read=0;write=0;reset=1;din=0;enable=1;
	#10;
	write=1;reset=0;
	din=3;
	#10;
	din=7;
	#10;
	din=4;
	#5;
	din=5;
	#5;
	write=0;read=1;
	#20;
	#10;
	#20;
	
	read=0;
	$finish();
	end
	endmodule
