`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 03:04:00 PM
// Design Name: 
// Module Name: build_output
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


module build_output(
    input [7:0] input_data,
    input clk
    );
    
    initial begin
        //open file
    end
    
    integer count=-4;
    integer outfile;
    integer pixel_count=0;
    parameter height=1280;
    parameter width=720;
    
   
    
    initial begin
        outfile=$fopen("test.mem","w");
  
       
    end
    
    always@(posedge clk) begin
        count=count+1;
        
        if (count %3==0 & count>0) begin
            if(pixel_count < (height*width))begin
                
                if(pixel_count%width==0 & !(pixel_count==0))begin
                    $fwrite(outfile,"\n");
                end
               
                $fwrite(outfile,"%h  ",input_data);
                
                
                
                pixel_count=pixel_count+1;
         
                
                
            end
            
            //write to file
        end
        
        
        
        if(pixel_count == (height*width)) begin
            $fclose(outfile);
        end
    end
    
    
    
    
    
    
endmodule
