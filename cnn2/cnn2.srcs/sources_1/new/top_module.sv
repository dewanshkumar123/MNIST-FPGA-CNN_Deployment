`timescale 1ns / 1ps

module reading(clk,m,over);
input clk;
parameter n=28;
output reg signed [7:0]m[n-1:0][n-1:0];
output reg over;
reg write=0;
reg read=1;
reg [7:0]din=0;
reg signed [7:0]memory[783:0];
reg [9:0]k;
integer i,j;


wire [7:0]dout;
reg [9:0] addr_next1,addr_next2;
reg [9:0]addr_write;
reg [9:0]addr_read;
reg [9:0]count;

// Incrementing the pointer
always@(posedge clk)
begin
addr_read<=addr_next1;
addr_write<=addr_next2;
end

initial begin
addr_read=0;
addr_write=0;
addr_next1=0;
addr_next2=0;
count=-1;
end


blk_mem_gen_0 Reading_from_bram (
  .clka(clk),    // input wire clka
  .wea(write),      // input wire [0 : 0] wea
  .addra(addr_write),  // input wire [9 : 0] addra
  .dina(din),    // input wire [7 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(read),      // input wire enb
  .addrb(addr_read),  // input wire [9 : 0] addrb
  .doutb(dout)  // output wire [7 : 0] doutb
);


//write operation
always@(posedge clk)
begin
    if (write)
    begin
        if (addr_next2==10'b1100010001)
               addr_next2=addr_write;
        else
               addr_next2=addr_write+1;
    end
    
    else
        addr_next2=addr_next2;
end


//read operation
always@(posedge clk)
begin

    if (read)
    begin
         if (addr_next1>10'b1100010000)
                begin
                addr_next1=addr_next1;
                count=count;
                end
         else
                begin
                addr_next1=addr_next1+1;
                count=count+1;
                end
    end
    else
        addr_next1=addr_next1;
end

        

always@(posedge clk)
begin
    if (read && count<10'b1100010001)
        begin
        memory[count]<=$signed(dout);
        over=0;
        end
    else
        #0.0025;
        over=1;
                       
end


always@(over)
begin
    k = 0;
        for (i = 0; i < n; i = i + 1) begin
            for (j = 0; j < n; j = j + 1) begin
                m[i][j] = $signed(memory[k]);
                k = k + 1;
            end
        end
end

endmodule





//module relu (
//    input signed [7:0] x,
//    output reg signed [7:0] y
//); 
//always @(x) begin
//    if (x >= 0) begin
//        y = x;
//    end
//    else begin
//        y = 0;
//    end
//end
//endmodule


module max_pooling(
    input signed [7:0] input_data [25:0][25:0], 
    output reg signed [7:0] output_data [12:0][12:0] 
);
reg [7:0] max_val;
integer i, j, k, l;

always @(*) begin
    for (i = 0; i < 13; i = i + 1) begin
        for (j = 0; j < 13; j = j + 1) begin
            max_val = 0; 
            for (k = 0; k < 2; k = k + 1) begin
                for (l = 0; l < 2; l = l + 1) begin
                    if (input_data[2*i+k][2*j+l] > max_val)
                        max_val = input_data[2*i+k][2*j+l]; 
                end
            end
            output_data[i][j] = max_val; 
        end
    end
end

endmodule


module convolution(
    input signed [7:0] input_matrix [27:0][27:0],
    input signed [7:0] kernel [2:0][2:0],
    output reg signed [7:0] output_matrix [25:0][25:0] // Corrected the size of output_matrix
    
);
parameter WIDTH = 28;
parameter KERNEL_SIZE = 3;
reg signed [9:0] conv_sum;
integer i, j, m, n;
always @(*) begin
#90;
    for (i = 0; i < WIDTH - KERNEL_SIZE + 1; i = i + 1) begin
        for (j = 0; j < WIDTH - KERNEL_SIZE + 1; j = j + 1) begin
            conv_sum = 0;
            for (m = 0; m < KERNEL_SIZE; m = m + 1) begin
                for (n = 0; n < KERNEL_SIZE; n = n + 1) begin
                    conv_sum = conv_sum + (input_matrix[i + m][j + n] * kernel[m][n])/127;
                    
                end
            end
            conv_sum=(conv_sum)/3;
            if ((conv_sum)>127)
                output_matrix[i][j] =127;
            else if ((conv_sum)<0)
                output_matrix[i][j] =0; //Applying Relu
            else
            output_matrix[i][j] = (conv_sum);
            
        end
    end
end
endmodule




module fully_connected_module (
    input signed [7:0] X[5407:0],   // Input vector X
    input signed [7:0] W[63:0][5407:0], // Weight matrix W
    input signed [7:0] b[63:0],   // Bias vector b
    output reg signed [7:0] Z[63:0]   // Output vector Z
);

parameter N = 5408;   // Input size
parameter M = 64;     // Output size
integer i, j;
reg signed [15:0] Z_temp[63:0]; // Temporary variable
                                
always @(*) begin
#800;
    for (i = 0; i < M; i = i + 1) begin
        Z_temp[i] = 0;
        for (j = 0; j < N; j = j + 1) begin
            Z_temp[i] = Z_temp[i] + (X[j] * W[i][j])/127;
        end
        Z_temp[i] = Z_temp[i] + b[i];
        Z[i] = Z_temp[i]/381;
    end
end

endmodule



module output_layer_module (
    input signed [7:0] X[63:0],   // Input vector X
    input signed [7:0] W[9:0][63:0], // Weight matrix W
    input signed [7:0] b[9:0],   // Bias vector b
    output reg signed [7:0] Z[9:0]   // Output vector Z
);

parameter N = 64;   // Input size
parameter M = 10;     // Output size
integer x, y;
reg signed [9:0] Z_temp[9:0]; // Temporary variable

always @(*) begin
#900;
    for (x = 0; x < M; x = x + 1) begin
        Z_temp[x] = 0;
        for (y = 0; y < N; y = y + 1) begin
            Z_temp[x] = Z_temp[x] +( X[y] * W[x][y])/127;
        end
    end
end


always @* begin
#40;
    for (integer i = 0; i < M; i = i + 1) begin
//        if (Z[i]>0)
        Z[i] =  Z_temp[i]+b[i];
//        else
//        Z[i]=0; // Only lower 8 bits assigned to Z
        
    end
    
end
endmodule


module top_module(clk,out);

input clk;
reg [7:0]m[27:0][27:0];
reg over;

reading r1(clk,m,over); // READING IMAGE VALUES

// FILTER VALUES
reg [7:0]filter1[2:0][2:0];
reg [7:0]filter2[2:0][2:0];
reg [7:0]filter3[2:0][2:0];
reg [7:0]filter4[2:0][2:0];
reg [7:0]filter5[2:0][2:0];
reg [7:0]filter6[2:0][2:0];
reg [7:0]filter7[2:0][2:0];
reg [7:0]filter8[2:0][2:0];
reg [7:0]filter9[2:0][2:0];
reg [7:0]filter10[2:0][2:0];
reg [7:0]filter11[2:0][2:0];
reg [7:0]filter12[2:0][2:0];
reg [7:0]filter13[2:0][2:0];
reg [7:0]filter14[2:0][2:0];
reg [7:0]filter15[2:0][2:0];
reg [7:0]filter16[2:0][2:0];
reg [7:0]filter17[2:0][2:0];
reg [7:0]filter18[2:0][2:0];
reg [7:0]filter19[2:0][2:0];
reg [7:0]filter20[2:0][2:0];
reg [7:0]filter21[2:0][2:0];
reg [7:0]filter22[2:0][2:0];
reg [7:0]filter23[2:0][2:0];
reg [7:0]filter24[2:0][2:0];
reg [7:0]filter25[2:0][2:0];
reg [7:0]filter26[2:0][2:0];
reg [7:0]filter27[2:0][2:0];
reg [7:0]filter28[2:0][2:0];
reg [7:0]filter29[2:0][2:0];
reg [7:0]filter30[2:0][2:0];
reg [7:0]filter31[2:0][2:0];
reg [7:0]filter32[2:0][2:0];


assign filter1[0][0]=26;
assign filter1[0][1]=28;
assign filter1[0][2]=25;
assign filter1[1][0]=17;
assign filter1[1][1]=25;
assign filter1[1][2]=-3;
assign filter1[2][0]=45;
assign filter1[2][1]=23;
assign filter1[2][2]=5;
assign filter2[0][0]=81;
assign filter2[0][1]=-60;
assign filter2[0][2]=-128;
assign filter2[1][0]=95;
assign filter2[1][1]=43;
assign filter2[1][2]=-109;
assign filter2[2][0]=58;
assign filter2[2][1]=81;
assign filter2[2][2]=-27;
assign filter3[0][0]=-73;
assign filter3[0][1]=50;
assign filter3[0][2]=86;
assign filter3[1][0]=-22;
assign filter3[1][1]=7;
assign filter3[1][2]=10;
assign filter3[2][0]=-91;
assign filter3[2][1]=57;
assign filter3[2][2]=67;
assign filter4[0][0]=-13;
assign filter4[0][1]=-68;
assign filter4[0][2]=-57;
assign filter4[1][0]=-49;
assign filter4[1][1]=24;
assign filter4[1][2]=-38;
assign filter4[2][0]=67;
assign filter4[2][1]=63;
assign filter4[2][2]=55;
assign filter5[0][0]=66;
assign filter5[0][1]=52;
assign filter5[0][2]=22;
assign filter5[1][0]=29;
assign filter5[1][1]=-51;
assign filter5[1][2]=-37;
assign filter5[2][0]=-79;
assign filter5[2][1]=-25;
assign filter5[2][2]=28;
assign filter6[0][0]=-47;
assign filter6[0][1]=6;
assign filter6[0][2]=5;
assign filter6[1][0]=-106;
assign filter6[1][1]=-13;
assign filter6[1][2]=98;
assign filter6[2][0]=-93;
assign filter6[2][1]=52;
assign filter6[2][2]=85;
assign filter7[0][0]=10;
assign filter7[0][1]=10;
assign filter7[0][2]=-33;
assign filter7[1][0]=19;
assign filter7[1][1]=-23;
assign filter7[1][2]=-23;
assign filter7[2][0]=-42;
assign filter7[2][1]=-21;
assign filter7[2][2]=48;
assign filter8[0][0]=-111;
assign filter8[0][1]=14;
assign filter8[0][2]=86;
assign filter8[1][0]=-75;
assign filter8[1][1]=27;
assign filter8[1][2]=51;
assign filter8[2][0]=48;
assign filter8[2][1]=75;
assign filter8[2][2]=16;
assign filter9[0][0]=19;
assign filter9[0][1]=70;
assign filter9[0][2]=94;
assign filter9[1][0]=40;
assign filter9[1][1]=-36;
assign filter9[1][2]=-26;
assign filter9[2][0]=-85;
assign filter9[2][1]=-37;
assign filter9[2][2]=-60;
assign filter10[0][0]=82;
assign filter10[0][1]=8;
assign filter10[0][2]=-94;
assign filter10[1][0]=93;
assign filter10[1][1]=0;
assign filter10[1][2]=-114;
assign filter10[2][0]=63;
assign filter10[2][1]=-4;
assign filter10[2][2]=-28;
assign filter11[0][0]=12;
assign filter11[0][1]=36;
assign filter11[0][2]=11;
assign filter11[1][0]=-38;
assign filter11[1][1]=-9;
assign filter11[1][2]=44;
assign filter11[2][0]=-8;
assign filter11[2][1]=-30;
assign filter11[2][2]=-38;
assign filter12[0][0]=1;
assign filter12[0][1]=-9;
assign filter12[0][2]=52;
assign filter12[1][0]=-37;
assign filter12[1][1]=-16;
assign filter12[1][2]=-3;
assign filter12[2][0]=15;
assign filter12[2][1]=-36;
assign filter12[2][2]=9;
assign filter13[0][0]=-85;
assign filter13[0][1]=-45;
assign filter13[0][2]=-105;
assign filter13[1][0]=14;
assign filter13[1][1]=-2;
assign filter13[1][2]=13;
assign filter13[2][0]=101;
assign filter13[2][1]=41;
assign filter13[2][2]=74;
assign filter14[0][0]=29;
assign filter14[0][1]=11;
assign filter14[0][2]=-3;
assign filter14[1][0]=17;
assign filter14[1][1]=-30;
assign filter14[1][2]=-34;
assign filter14[2][0]=-16;
assign filter14[2][1]=-22;
assign filter14[2][2]=34;
assign filter15[0][0]=-26;
assign filter15[0][1]=-31;
assign filter15[0][2]=-5;
assign filter15[1][0]=24;
assign filter15[1][1]=3;
assign filter15[1][2]=-13;
assign filter15[2][0]=-27;
assign filter15[2][1]=8;
assign filter15[2][2]=-31;
assign filter16[0][0]=38;
assign filter16[0][1]=39;
assign filter16[0][2]=18;
assign filter16[1][0]=14;
assign filter16[1][1]=15;
assign filter16[1][2]=39;
assign filter16[2][0]=-95;
assign filter16[2][1]=-26;
assign filter16[2][2]=-18;
assign filter17[0][0]=-8;
assign filter17[0][1]=-46;
assign filter17[0][2]=-87;
assign filter17[1][0]=60;
assign filter17[1][1]=41;
assign filter17[1][2]=-11;
assign filter17[2][0]=34;
assign filter17[2][1]=2;
assign filter17[2][2]=5;
assign filter18[0][0]=12;
assign filter18[0][1]=35;
assign filter18[0][2]=4;
assign filter18[1][0]=7;
assign filter18[1][1]=-17;
assign filter18[1][2]=-44;
assign filter18[2][0]=-37;
assign filter18[2][1]=29;
assign filter18[2][2]=35;
assign filter19[0][0]=41;
assign filter19[0][1]=24;
assign filter19[0][2]=-33;
assign filter19[1][0]=15;
assign filter19[1][1]=-22;
assign filter19[1][2]=-10;
assign filter19[2][0]=-5;
assign filter19[2][1]=-14;
assign filter19[2][2]=-29;
assign filter20[0][0]=-90;
assign filter20[0][1]=30;
assign filter20[0][2]=66;
assign filter20[1][0]=-7;
assign filter20[1][1]=52;
assign filter20[1][2]=1;
assign filter20[2][0]=72;
assign filter20[2][1]=11;
assign filter20[2][2]=-19;
assign filter21[0][0]=-88;
assign filter21[0][1]=-16;
assign filter21[0][2]=103;
assign filter21[1][0]=34;
assign filter21[1][1]=60;
assign filter21[1][2]=25;
assign filter21[2][0]=83;
assign filter21[2][1]=27;
assign filter21[2][2]=-18;
assign filter22[0][0]=21;
assign filter22[0][1]=17;
assign filter22[0][2]=17;
assign filter22[1][0]=36;
assign filter22[1][1]=-18;
assign filter22[1][2]=17;
assign filter22[2][0]=-38;
assign filter22[2][1]=13;
assign filter22[2][2]=42;
assign filter23[0][0]=-61;
assign filter23[0][1]=-42;
assign filter23[0][2]=-28;
assign filter23[1][0]=-19;
assign filter23[1][1]=-21;
assign filter23[1][2]=29;
assign filter23[2][0]=78;
assign filter23[2][1]=63;
assign filter23[2][2]=8;
assign filter24[0][0]=-37;
assign filter24[0][1]=-61;
assign filter24[0][2]=-28;
assign filter24[1][0]=97;
assign filter24[1][1]=92;
assign filter24[1][2]=79;
assign filter24[2][0]=-47;
assign filter24[2][1]=-69;
assign filter24[2][2]=-20;
assign filter25[0][0]=55;
assign filter25[0][1]=-9;
assign filter25[0][2]=-7;
assign filter25[1][0]=18;
assign filter25[1][1]=17;
assign filter25[1][2]=-10;
assign filter25[2][0]=-22;
assign filter25[2][1]=-32;
assign filter25[2][2]=-47;
assign filter26[0][0]=1;
assign filter26[0][1]=64;
assign filter26[0][2]=-26;
assign filter26[1][0]=68;
assign filter26[1][1]=14;
assign filter26[1][2]=-41;
assign filter26[2][0]=-2;
assign filter26[2][1]=-27;
assign filter26[2][2]=-68;
assign filter27[0][0]=-43;
assign filter27[0][1]=-13;
assign filter27[0][2]=-21;
assign filter27[1][0]=12;
assign filter27[1][1]=-11;
assign filter27[1][2]=-25;
assign filter27[2][0]=19;
assign filter27[2][1]=17;
assign filter27[2][2]=-7;
assign filter28[0][0]=-15;
assign filter28[0][1]=50;
assign filter28[0][2]=-63;
assign filter28[1][0]=-35;
assign filter28[1][1]=0;
assign filter28[1][2]=-60;
assign filter28[2][0]=27;
assign filter28[2][1]=81;
assign filter28[2][2]=-2;
assign filter29[0][0]=61;
assign filter29[0][1]=-3;
assign filter29[0][2]=0;
assign filter29[1][0]=5;
assign filter29[1][1]=-9;
assign filter29[1][2]=1;
assign filter29[2][0]=-16;
assign filter29[2][1]=-20;
assign filter29[2][2]=-51;
assign filter30[0][0]=88;
assign filter30[0][1]=-105;
assign filter30[0][2]=-123;
assign filter30[1][0]=121;
assign filter30[1][1]=51;
assign filter30[1][2]=-15;
assign filter30[2][0]=10;
assign filter30[2][1]=89;
assign filter30[2][2]=110;
assign filter31[0][0]=-6;
assign filter31[0][1]=33;
assign filter31[0][2]=-18;
assign filter31[1][0]=-20;
assign filter31[1][1]=6;
assign filter31[1][2]=-25;
assign filter31[2][0]=4;
assign filter31[2][1]=-2;
assign filter31[2][2]=12;
assign filter32[0][0]=37;
assign filter32[0][1]=9;
assign filter32[0][2]=-48;
assign filter32[1][0]=-18;
assign filter32[1][1]=56;
assign filter32[1][2]=-21;
assign filter32[2][0]=-5;
assign filter32[2][1]=0;
assign filter32[2][2]=36;

/// // CONVOLUTION OF IMAGE AND FILTERS. (OUT=32 FEATURE MAPS)
reg [7:0] feature_map1 [25:0][25:0];
convolution F1(m,filter1,feature_map1);
reg [7:0] feature_map2 [25:0][25:0];
convolution F2(m,filter2,feature_map2);
reg [7:0] feature_map3 [25:0][25:0];
convolution F3(m,filter3,feature_map3);
reg [7:0] feature_map4 [25:0][25:0];
convolution F4(m,filter4,feature_map4);
reg [7:0] feature_map5 [25:0][25:0];
convolution F5(m,filter5,feature_map5);
reg [7:0] feature_map6 [25:0][25:0];
convolution F6(m,filter6,feature_map6);
reg [7:0] feature_map7 [25:0][25:0];
convolution F7(m,filter7,feature_map7);
reg [7:0] feature_map8 [25:0][25:0];
convolution F8(m,filter8,feature_map8);
reg [7:0] feature_map9 [25:0][25:0];
convolution F9(m,filter9,feature_map9);
reg [7:0] feature_map10 [25:0][25:0];
convolution F10(m,filter10,feature_map10);
reg [7:0] feature_map11 [25:0][25:0];
convolution F11(m,filter11,feature_map11);
reg [7:0] feature_map12 [25:0][25:0];
convolution F12(m,filter12,feature_map12);
reg [7:0] feature_map13 [25:0][25:0];
convolution F13(m,filter13,feature_map13);
reg [7:0] feature_map14 [25:0][25:0];
convolution F14(m,filter14,feature_map14);
reg [7:0] feature_map15 [25:0][25:0];
convolution F15(m,filter15,feature_map15);
reg [7:0] feature_map16 [25:0][25:0];
convolution F16(m,filter16,feature_map16);
reg [7:0] feature_map17 [25:0][25:0];
convolution F17(m,filter17,feature_map17);
reg [7:0] feature_map18 [25:0][25:0];
convolution F18(m,filter18,feature_map18);
reg [7:0] feature_map19 [25:0][25:0];
convolution F19(m,filter19,feature_map19);
reg [7:0] feature_map20 [25:0][25:0];
convolution F20(m,filter20,feature_map20);
reg [7:0] feature_map21 [25:0][25:0];
convolution F21(m,filter21,feature_map21);
reg [7:0] feature_map22 [25:0][25:0];
convolution F22(m,filter22,feature_map22);
reg [7:0] feature_map23 [25:0][25:0];
convolution F23(m,filter23,feature_map23);
reg [7:0] feature_map24 [25:0][25:0];
convolution F24(m,filter24,feature_map24);
reg [7:0] feature_map25 [25:0][25:0];
convolution F25(m,filter25,feature_map25);
reg [7:0] feature_map26 [25:0][25:0];
convolution F26(m,filter26,feature_map26);
reg [7:0] feature_map27 [25:0][25:0];
convolution F27(m,filter27,feature_map27);
reg [7:0] feature_map28 [25:0][25:0];
convolution F28(m,filter28,feature_map28);
reg [7:0] feature_map29 [25:0][25:0];
convolution F29(m,filter29,feature_map29);
reg [7:0] feature_map30 [25:0][25:0];
convolution F30(m,filter30,feature_map30);
reg [7:0] feature_map31 [25:0][25:0];
convolution F31(m,filter31,feature_map31);
reg [7:0] feature_map32 [25:0][25:0];
convolution F32(m,filter32,feature_map32);


//// MAX POOLING OUTPUT 32 FEATURE MAPS (SHRINKED)
reg [7:0] pooled1[12:0][12:0];
max_pooling P1(feature_map1, pooled1);
reg [7:0] pooled2[12:0][12:0];
max_pooling P2(feature_map2, pooled2);
reg [7:0] pooled3[12:0][12:0];
max_pooling P3(feature_map3, pooled3);
reg [7:0] pooled4[12:0][12:0];
max_pooling P4(feature_map4, pooled4);
reg [7:0] pooled5[12:0][12:0];
max_pooling P5(feature_map5, pooled5);
reg [7:0] pooled6[12:0][12:0];
max_pooling P6(feature_map6, pooled6);
reg [7:0] pooled7[12:0][12:0];
max_pooling P7(feature_map7, pooled7);
reg [7:0] pooled8[12:0][12:0];
max_pooling P8(feature_map8, pooled8);
reg [7:0] pooled9[12:0][12:0];
max_pooling P9(feature_map9, pooled9);
reg [7:0] pooled10[12:0][12:0];
max_pooling P10(feature_map10, pooled10);
reg [7:0] pooled11[12:0][12:0];
max_pooling P11(feature_map11, pooled11);
reg [7:0] pooled12[12:0][12:0];
max_pooling P12(feature_map12, pooled12);
reg [7:0] pooled13[12:0][12:0];
max_pooling P13(feature_map13, pooled13);
reg [7:0] pooled14[12:0][12:0];
max_pooling P14(feature_map14, pooled14);
reg [7:0] pooled15[12:0][12:0];
max_pooling P15(feature_map15, pooled15);
reg [7:0] pooled16[12:0][12:0];
max_pooling P16(feature_map16, pooled16);
reg [7:0] pooled17[12:0][12:0];
max_pooling P17(feature_map17, pooled17);
reg [7:0] pooled18[12:0][12:0];
max_pooling P18(feature_map18, pooled18);
reg [7:0] pooled19[12:0][12:0];
max_pooling P19(feature_map19, pooled19);
reg [7:0] pooled20[12:0][12:0];
max_pooling P20(feature_map20, pooled20);
reg [7:0] pooled21[12:0][12:0];
max_pooling P21(feature_map21, pooled21);
reg [7:0] pooled22[12:0][12:0];
max_pooling P22(feature_map22, pooled22);
reg [7:0] pooled23[12:0][12:0];
max_pooling P23(feature_map23, pooled23);
reg [7:0] pooled24[12:0][12:0];
max_pooling P24(feature_map24, pooled24);
reg [7:0] pooled25[12:0][12:0];
max_pooling P25(feature_map25, pooled25);
reg [7:0] pooled26[12:0][12:0];
max_pooling P26(feature_map26, pooled26);
reg [7:0] pooled27[12:0][12:0];
max_pooling P27(feature_map27, pooled27);
reg [7:0] pooled28[12:0][12:0];
max_pooling P28(feature_map28, pooled28);
reg [7:0] pooled29[12:0][12:0];
max_pooling P29(feature_map29, pooled29);
reg [7:0] pooled30[12:0][12:0];
max_pooling P30(feature_map30, pooled30);
reg [7:0] pooled31[12:0][12:0];
max_pooling P31(feature_map31, pooled31);
reg [7:0] pooled32[12:0][12:0];
max_pooling P32(feature_map32, pooled32);


//// FLATTENEING ALL FEATURE MAPS INTO 1 ARRAY
reg [7:0]flattened1[5407:0];
reg [18:0]k1;
integer c,d;
always@(over)

begin
#100;
k1=0;
    for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled1[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled2[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled3[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled4[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled5[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled6[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled7[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled8[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled9[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled10[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled11[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled12[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled13[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled14[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled15[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled16[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled17[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled18[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled19[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled20[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled21[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled22[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled23[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled24[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled25[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled26[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled27[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled28[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled29[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled30[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled31[c][d];
        k1 = k1 + 1;
    end
end
for (c=0; c<13; c=c+1) begin
    for (d=0; d<13; d=d+1) begin
        flattened1[k1] = pooled32[c][d];
        k1 = k1 + 1;
    end
end
end

reg signed [7:0]weight1_1[124383:0];
reg signed [7:0]weight1_2[124383:0];
reg signed [7:0]weight1_3[97343:0];
reg over4,over5,over6;

neurons1 W1(clk,weight1_1,over4);
neurons2 W2(clk,weight1_2,over6);
neurons3 W3(clk,weight1_3,over6);

reg [18:0]parag;
reg signed [7:0] layer1 [63:0][5407:0];

integer s1,s2;
always@(over4)
begin
#250;
    parag = 0;
        for (s1 = 0; s1 < 23; s1 = s1 + 1) begin
            for (s2 = 0; s2 < 5408; s2 = s2 + 1) begin
                layer1[s1][s2] = weight1_1[parag];
                parag = parag + 1;
            end
        end
    parag=0;    
        for (integer s3 = 23; s3 < 46; s3 = s3 + 1) begin
            for (integer s4 = 0; s4 < 5408; s4 = s4 + 1) begin
                layer1[s3][s4] = weight1_2[parag];
                parag = parag + 1;
            end
        end
    parag=0;    
        for (s1 = 46; s1 < 64; s1 = s1 + 1) begin
            for (s2 = 0; s2 < 5408; s2 = s2 + 1) begin
                layer1[s1][s2] = weight1_3[parag];
                parag = parag + 1;
            end
        end
        
end

reg signed [7:0]bias1[63:0];
reg signed [7:0]inp_layer2[63:0];

assign bias1={ 2,  0,  4,  3,  3, -2, -1, -4,  0,  0, -2, -1,  0,  0,  0, 11,  0,  2,
         5,  0,  0,  0, -1,  0, -1,  0,  2, -1, -1, -1,  2,  0,  0,  0,  0,  9,
         9,  0, -3,  0,  9, -1, -2,  0, -1,  3, -1,  0,  0, -1, -2,  2, -2, -4,
         0, -5,  0,  2,  0, -1, -2, -3,  8,  0};
fully_connected_module first_layer(flattened1,layer1, bias1,inp_layer2);


reg signed [7:0]weights2[639:0];
reg over9;

neurons_last read_outlayer_wei(clk,weights2,over9);

integer s3,s4;
reg [10:0]john;



reg signed [7:0] arr_wei_2 [9:0][63:0];

assign arr_wei_2[9][63]=6;

always@(over5)
begin
#250;
    john = 0;
        for (integer s9 = 0; s9 < 10; s9 = s9 + 1) begin
            for (integer s10= 0; s10 < 64; s10 = s10 + 1) begin
                arr_wei_2[s9][s10] = weights2[john];
                john = john + 1;
            end
        end
 
end




reg signed [7:0]bias2[9:0];
//assign bias2={12,7,17,-13,-13,-8,-10,-4,17,5};

assign bias2[0]=12;
assign bias2[1]= 7;
assign bias2[2]=17;
assign bias2[3]= -13;
assign bias2[4]=-13;
assign bias2[5]= -8;
assign bias2[6]=-10;
assign bias2[7]= -4;
assign bias2[8]=17;
assign bias2[9]= 5;
reg signed [7:0]final_out[9:0];

 
output_layer_module final_cal(inp_layer2,arr_wei_2,bias2,final_out);

reg [7:0] max;
reg [3:0]index;
output reg [3:0]out;

always@(*)
begin

max = -127;
index=0;


for (integer l = 0; l < 10; l = l + 1) begin
        if ((final_out[l])>max) begin
        max=(final_out[l]);
        index=l;
        end
        
        else 
        begin
        max = max; 
        index = index;
        end
        
    end

assign out=index;



end
endmodule



module neurons1(clk,weights1,over4);
input clk;
parameter n=28;
output reg [7:0]weights1[124383:0];
output reg over4;
reg write=0;
reg read=1;
reg [7:0]din=0;
reg [18:0]k;
reg over;
integer i,j;


wire [7:0]dout;
reg [18:0] addr_next1,addr_next2;
reg [18:0]addr_write;
reg [18:0]addr_read;
reg [18:0]count;

// Incrementing the pointer
always@(posedge clk)
begin
addr_read<=addr_next1;
addr_write<=addr_next2;
end

initial begin
addr_read=0;
addr_write=0;
addr_next1=0;
addr_next2=0;
count=-1;
over4=0;
end


blk_mem_gen_1 weights_r_1(
  .clka(clk),    // input wire clka
  .wea(write),      // input wire [0 : 0] wea
  .addra(addr_write),  // input wire [9 : 0] addra
  .dina(din),    // input wire [7 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(read),      // input wire enb
  .addrb(addr_read),  // input wire [9 : 0] addrb
  .doutb(dout)  // output wire [7 : 0] doutb
);



//write operation
always@(posedge clk)
begin
    if (write)
    begin
        if (addr_next2==19'd124384)
               addr_next2=addr_write;
        else
               addr_next2=addr_write+1;
    end
    
    else
        addr_next2=addr_next2;
end


//read operation
always@(posedge clk)
begin

    if (read)
    begin
         if (addr_next1>19'd124384)
                begin
                addr_next1=addr_next1;
                count=count;
                end
         else
                begin
                addr_next1=addr_next1+1;
                count=count+1;
                end
    end
    else
        addr_next1=addr_next1;
end

        
always@(posedge clk)
begin
    if (read && count<19'd124384)
        begin
        weights1[count]<=(dout/3);
        over4=0;
        end
    else
        #0.0025;
        over4=1;
                       
end
endmodule



module neurons2(clk,weights1_2,over412);
input clk;
parameter n=28;
output reg [7:0]weights1_2[124383:0];
output reg over412;
reg write12=0;
reg read12=1;
reg [7:0]din12=0;
reg [18:0]k;
reg over;
integer i,j;


wire [7:0]dout12;
reg [18:0] addr_next112,addr_next212;
reg [18:0]addr_write12;
reg [18:0]addr_read12;
reg [18:0]count12;

//assign addr_next112=19'd124385;
//assign count12=124385;
//assign addr_read12= 19'd124385;
// Incrementing the pointer
always@(posedge clk)
begin
addr_read12<=addr_next112;
addr_write12<=addr_next212;
end

initial begin
addr_read12= 0;
addr_write12=0;
addr_next112=0;
addr_next212=0;
count12=-1;
over412=0;
end


blk_mem_gen_3 weights_r_2(
  .clka(clk),    // input wire clka
  .wea(write12),      // input wire [0 : 0] wea
  .addra(addr_write12),  // input wire [9 : 0] addra
  .dina(din12),    // input wire [7 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(read12),      // input wire enb
  .addrb(addr_read12),  // input wire [9 : 0] addrb
  .doutb(dout12)  // output wire [7 : 0] doutb
);



//write operation
always@(posedge clk)
begin
    if (write12)
    begin
        if (addr_next212==19'd124384)
               addr_next212=addr_write12;
        else
               addr_next212=addr_write12+1;
    end
    
    else
        addr_next212=addr_next212;
end


//read operation
always@(posedge clk)
begin

    if (read12)
    begin
         if (addr_next112>19'd124384)
                begin
                addr_next112=addr_next112;
                count12=count12;
                end
         else
                begin
                addr_next112=addr_next112+1;
                count12=count12+1;
                end
    end
    else
        addr_next112=addr_next112;
end

        
always@(posedge clk)
begin
    if (read12 && count12<19'd124384)
        begin
        weights1_2[count12]<=(dout12/3);
        over412=0;
        end
    else
        #0.0005;
        over412=1;
                       
end
endmodule


module neurons3(clk,weights1,over4);
input clk;
parameter n=28;
output reg [7:0]weights1[97343:0];
output reg over4;
reg write=0;
reg read=1;
reg [7:0]din=0;
reg [18:0]k;
reg over;
integer i,j;


wire [7:0]dout;
reg [18:0] addr_next1,addr_next2;
reg [18:0]addr_write;
reg [18:0]addr_read;
reg [18:0]count;

// Incrementing the pointer
always@(posedge clk)
begin
addr_read<=addr_next1;
addr_write<=addr_next2;
end

initial begin
addr_read= 0;
addr_write=0;
addr_next1=0;
addr_next2=0;
count=0;
over4=0;
end


blk_mem_gen_4 weights_r_3(
  .clka(clk),    // input wire clka
  .wea(write),      // input wire [0 : 0] wea
  .addra(addr_write),  // input wire [9 : 0] addra
  .dina(din),    // input wire [7 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(read),      // input wire enb
  .addrb(addr_read),  // input wire [9 : 0] addrb
  .doutb(dout)  // output wire [7 : 0] doutb
);



//write operation
always@(posedge clk)
begin
    if (write)
    begin
        if (addr_next2==19'd97344)
               addr_next2=addr_write;
        else
               addr_next2=addr_write+1;
    end
    
    else
        addr_next2=addr_next2;
end


//read operation
always@(posedge clk)
begin

    if (read)
    begin
         if (addr_next1>19'd97344)
                begin
                addr_next1=addr_next1;
                count=count;
                end
         else
                begin
                addr_next1=addr_next1+1;
                count=count+1;
                end
    end
    else
        addr_next1=addr_next1;
end

        
always@(posedge clk)
begin
    if (read && count<19'd97344)
        begin
        weights1[count]<=(dout/3);
        over4=0;
        end
    else
        #0.0025;
        over4=1;
                       
end
endmodule


module neurons_last (clk,weights4,over4);
input clk;
output reg [7:0]weights4[639:0];
output reg over4;
reg write4=0;
reg read4=1;
reg [7:0]din4=0;

wire [7:0]dout4;
reg [10:0] addr_next14,addr_next24;
reg [10:0]addr_write4;
reg [10:0]addr_read4;
reg [10:0]count4;

// Incrementing the pointer
always@(posedge clk)
begin
addr_read4<=addr_next14;
addr_write4<=addr_next24;
end

initial begin
addr_read4=0;
addr_write4=0;
addr_next14=0;
addr_next24=0;
count4=-1;
over4=0;
end


blk_mem_gen_5 weights_r_1n(
  .clka(clk),    // input wire clka
  .wea(write4),      // input wire [0 : 0] wea
  .addra(addr_write4),  // input wire [9 : 0] addra
  .dina(din4),    // input wire [7 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(read4),      // input wire enb
  .addrb(addr_read4),  // input wire [9 : 0] addrb
  .doutb(dout4)  // output wire [7 : 0] doutb
);


//write operation
always@(posedge clk)
begin
    if (write4)
    begin
        if (addr_next24==11'd640)
               addr_next24=addr_write4;
        else
               addr_next24=addr_next24+1;
    end
    
    else
        addr_next24=addr_next24;
end


//read operation
always@(posedge clk)
begin

 if (read4)
    begin
         if (addr_next14>11'd641)
                begin
                
                addr_next14=addr_next14;
                count4=count4;
                end
         else
                begin
                
                addr_next14=addr_next14+1;
                count4=count4+1;
                end
    end
    else
        addr_next14=addr_next14;
end

        
always@(posedge clk)
begin
    if (read4 && count4<11'd641)
        begin
        weights4[count4]<=(dout4);
        over4=0;
        end
    else
        
        over4=1;
                       
end
endmodule