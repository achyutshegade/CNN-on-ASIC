`timescale 1ns / 1ps

module IAG #(parameter w=220, h=220)(
    input clk,rstn,fetch,slide,
    input [3:0] m,
    input [9:0]pixel_count,
    output wire [15:0]img_addr,
    output reg [15:0]res_addr,
    output reg ker_complete,conv_complete
    );

    reg [15:0]base_addr;
    reg [9:0]offset;
    reg [9:0]col_offset, row_offset;
    reg [9:0]col_addr;
    
    
    always @(*)
    begin
        if(!rstn)
         begin
            base_addr =0;
            offset=0;
            col_offset=0;
            row_offset=0;
            col_addr=1;
            conv_complete=0;
          end
        else if(fetch)
            begin
            base_addr = (w*row_offset)+col_offset;
            ker_complete=0;
            
            if(pixel_count==0)offset=0;
            else
                begin
                if(col_addr<m)
                     begin
                       offset = offset+1;
                       col_addr=col_addr+1; 
                     end
                else if(col_addr==(m))
                     begin
                        offset = offset+(w-m+1);
                        col_addr=1; 
                     end
                end
          
            if(pixel_count==(((m*m)-1)/2))res_addr=base_addr+offset;
            end
            if(fetch==0)
                begin
                col_addr=1;
                offset=0;
                base_addr = (w*row_offset)+col_offset;
                end
            if(slide)
            begin
                if(col_offset<w-m+1)
                col_offset = col_offset+1;
                else if(row_offset<h-m+1)
                begin
                col_offset = 0;
                row_offset = row_offset+1;
                end
            else
                conv_complete=1;
            end
    end
    assign img_addr = base_addr+offset;
endmodule
