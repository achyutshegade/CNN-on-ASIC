`timescale 1ns / 1ps

module KAG #(parameter m=3)(
    input clk,rstn,
    input [6:0]addr,
    input [(m*m)-1:0] kernel,
    output out
    );
    reg k_mem[0:(m*m)-1];
    integer i;
    
    always @(negedge clk or negedge rstn)
     begin
        if(!rstn)
            begin
              for (i=0; i<=m; i=i+1)begin
                #1 k_mem[i]= 0;
              end
            end
        else
            begin
              for (i=0; i<=(m*m)-1; i=i+1)begin
                #1 k_mem[i]= kernel[i];
              end
            end
     end
     
     assign out = k_mem[addr];
endmodule
