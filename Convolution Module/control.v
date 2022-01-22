`timescale 1ns / 1ps

module control#(parameter [3:0]m=3,w=220, h=220)(
    input rstn,clk,ready,
    input [(m*m)-1:0] kernel,
    output wire [8:0] out,
    output reg finish
    );
    reg [9:0]pixel_count;
    reg [9:0]input_data;
    reg write_enable=0;
    reg fetch,slide;
    reg [6:0]ker_addr;
    reg ram_enable=1;
    reg [15:0]ram_addr;
    reg res_rst;
    reg [15:0]ker_res;
    wire [15:0] res;
    wire [15:0]res_addr;
    wire temp_clk;
    wire [15:0]img_addr;
    wire ker_val;
    wire [7:0]img_val;
    wire [15:0]product;
    wire ker_complete,conv_complete;
    
       
    assign temp_clk = ready&clk;
    assign out = res;
    
    
    KAG ker(clk,rstn,ker_addr,kernel,ker_val);
    IAG img(clk,rstn,fetch,slide,m,pixel_count,img_addr,res_addr,ker_complete,conv_complete);
    bram ram(clk,ram_enable,write_enable,ram_addr,input_data,img_val);
    Compute cmp(clk,rstn,ker_val,res_rst,img_val,res);
    
    reg [2:0] state;
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011;
    
       
    always @ (negedge clk)
    begin
       case(state)
         S0: if(ready) state <= S1;
        S1: begin
            if(pixel_count>=(m*m-1))state <= S2;
            end
        S2: begin
            if(conv_complete)state <= S3;
            else state<=S1;
            end       
        S3: #2 if(ready) state <= S0;
        default: state <= S0;
       endcase
     end
     
 
  always @ (negedge clk)
    begin
       ker_res = res;
       case(state)
        S0: begin 
            finish=0;
            slide=0;
            ker_addr=0;
            pixel_count=0;
            ker_res = 0;
            end
        S1: begin
            slide=0;
            fetch=1;
            ram_addr = img_addr;
            #1 pixel_count = pixel_count+1;
            #1 ker_addr=ker_addr+1;

            end
        S2: begin
            fetch=0;
            slide=1;
            #15 slide=0;
            ker_addr=0;
            ker_res =ker_res/(m*m);
            write_enable=1;
            input_data = ker_res;
            ram_addr = res_addr;
            #10 write_enable=0;
            res_rst=1;
            ker_res=0;
            pixel_count=0;
            #5 res_rst=0;
            end
        S3: finish=1;
       endcase
       
    end
endmodule
