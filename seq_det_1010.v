`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2026 00:46:33
// Design Name: 
// Module Name: seq_det_1010
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


module seq_det_1010(data_in, clk, rst, submit, unlocked, locked );
input data_in, clk, rst, submit;
output reg unlocked;
output reg locked;

    parameter idle=3'b000,
                S1=3'b001,
                S2=3'b010,
                S3=3'b011,
              unlock_state=3'b100,
              lock_state=3'b101,
              error_state=3'b110;
              
              reg [2:0]present_state, next_state;
              reg [1:0]error_count;
              
//       present state logic   
// Present state & sequential logic (Using ONLY non-blocking assignments)   
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            present_state <= idle;
            error_count   <= 2'b00;
        end else begin
            present_state <= next_state;
            
            // Increment error count only when we transition into the error state
            if (present_state != error_state && next_state == error_state) begin
                if (error_count < 3)
                    error_count <= error_count + 1'b1;
            end
            // Clear error count when successfully unlocked
            else if (present_state == unlock_state) begin
                error_count <= 2'b00;
            end
        end
    end
    
//next_state logic
always @(*)
    begin
        next_state= present_state;
        unlocked=1'b0;
        locked=1'b1;
        
//        password:1010
        case(present_state)
                idle: 
                begin
                    if(data_in==1'b1 && error_count<3)
                        next_state = S1;
                    else 
                        next_state = error_state;
                end 
                
                S1:
                begin
                    if(data_in==1'b0 && error_count<3)
                        next_state = S2;
                    else 
                        next_state= error_state;
                 end
                 
                 S2:
                 begin 
                    if(data_in==1'b1 && error_count<3 )
                        next_state=S3;
                    else
                    next_state=error_state;
                 end
                 
                 S3:
                 begin
                    if(data_in==1'b0 && error_count<3 )
                        next_state= unlock_state;
                    else
                        next_state= error_state;
                 end 
                 
                 unlock_state:
                 begin
                    unlocked= 1'b1;
                    locked=1'b0;
                    
                    if(submit)
                        next_state= idle;
                    else
                        next_state=unlock_state;
                 end 
                  error_state:
                   begin
                        unlocked= 1'b0;
                        locked= 1'b1;
                        
                        if(submit)
                            next_state= idle;
                        else
                            next_state= error_state;
                            
                    end
                        
                endcase
                
           end      
                  
endmodule
