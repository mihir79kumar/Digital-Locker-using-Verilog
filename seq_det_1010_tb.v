`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2026 01:37:17
// Design Name: 
// Module Name: seq_det_1010_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//module seq_det_1010_tb();

//reg data_in,clk,rst,submit;
//wire unlocked, locked;

//seq_det_1010 uut(data_in, clk, rst, submit, unlocked, locked);

//initial 
//    begin 
//        {clk, rst, submit , data_in}=0;
//    end
//always #5 clk= ~clk;
    
//initial 
//    begin 
//            rst = 1'b1 ;
//       @(negedge clk)
//            rst= 1'b0 ;
//            data_in= 1'b1 ;
     
//       @(negedge clk)
//            data_in= 1'b0;
            
//       @(negedge clk)
//            data_in= 1'b1;
            
//       @(negedge clk)
//            data_in= 1'b0;
//            submit= 1'b1 ;
            
//    end
       
       `timescale 1ns / 1ps

module seq_det_1010_tb();

reg data_in, clk, rst, submit;
wire unlocked, locked;

seq_det_1010 uut(data_in, clk, rst, submit, unlocked, locked);

reg [3:0] test_sequence = 4'b1010;
integer i;

initial begin 
    {clk, rst, submit, data_in} = 0;
end

always #5 clk = ~clk;
    
initial begin 
    rst = 1'b1;
    @(negedge clk);
    rst = 1'b0;
     
    for (i = 3; i >= 0; i = i - 1) begin
        data_in = test_sequence[i];
        if (i == 0) begin
            submit = 1'b1;
        end
        @(negedge clk);
    end
    
    submit = 1'b0;
    data_in = 1'b0;
end
       
endmodule

