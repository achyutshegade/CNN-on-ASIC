`timescale 1ns / 1ps

module test#(parameter [3:0] m=3)(

    );
    reg rstn,clk,ready;
    reg [(m*m)-1 : 0] kernel;
    wire [8:0] out;
    wire finish;
    
    control tb(rstn,clk,ready,kernel,out,finish);
    
    initial
    begin
    rstn=1;
    ready =0;
    clk =0;
    end
    
    always #5 clk =~clk;
    
    initial
    begin
    rstn =0;
    #10 rstn =1;
    #10 ready =1;
    #10 kernel = 9'b101011101;
    
    
    end
    
    initial
    begin
    $monitor("clk=%b,rstn=%b,ready=%b,out=%b, finish=%b",clk,rstn,ready,out,finish);
    end
    

endmodule
