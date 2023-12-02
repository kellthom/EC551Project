`timescale 1ns / 1ps



module sobel_new(
        input[15:0] height,
        input[15:0] width,
        input clk,
        input rstn,
        input[7:0] data_in,
        output reg signed[15:0] ROM_Edge

    );

    //The maximum width this file can handle
    parameter max_width=1000;
    
    //3 working rows must be stored at all times in order to calculate the gradient
    reg[7:0] working_rows [0:2][0:max_width];

    //Counting variables
    integer w_count = 0,
            h_count = 0,
            w_count_calc=0;
           
    //Gradients 
    reg signed[15:0]   Gx = 0,
                       Gy = 0;
 
    //Calculations do not begin until the third row is loaded
    reg preliminary=1;
    
    //Used in a for loop
    integer i;
 
 
    always@(posedge clk)begin
    
        //First, it will be necessary to load first two rows
        if(preliminary==1)begin
        
            working_rows[h_count][w_count]=data_in; //Load the data
            
            w_count=w_count+1; //Move to the next column
            
            //When we run out of columns, load the next row
            if (w_count==width)begin
                h_count=h_count+1;
                w_count=0;
            end
            
        //Enter this block once the first two rows have been loaded
        end else begin
            
            //If we reach the end of a row, perform a shift
            if(w_count==width)begin
                for (i=0;i<max_width;i=i+1) begin
                    working_rows[0][i]<=working_rows[1][i]; //The first row becomes the zeroth
                    working_rows[1][i]<=working_rows[2][i]; //The second row becomes the first
                end
                w_count=0;
                h_count=h_count+1;
            end
            
            
            //Add value to the row
            working_rows[2][w_count]=data_in;
            
            //Once we are two columns in, we can start performing calculations
            if (w_count>1)begin
            
                //For convenience
                w_count_calc=w_count-2;
                
                
                //Calulcate gradient and ROM_Edge Value
                Gx <=    -working_rows[2][w_count_calc] + working_rows[0][w_count_calc]          +
                    -2*working_rows[2][w_count_calc+1] + 2*working_rows[0][w_count_calc+1]  +
                    -working_rows[2][w_count_calc+2] + working_rows[0][w_count_calc+2]      ;
                
                Gy <=   -working_rows[2][w_count_calc] - 2*working_rows[1][w_count_calc] - working_rows[0][w_count_calc]       +
                    working_rows[2][w_count_calc+2] + 2*working_rows[1][w_count_calc+2] + working_rows[0][w_count_calc+2] ;
                    
                ROM_Edge=Gx + Gy;

                
            end
            
            //Move  to the next column
            w_count=w_count+1;
            
        end
        
        //Once the first two rows have been established, then shifts will handle everyhting else
        if(h_count==2)begin
            preliminary=0;
        end
        
        
        //End of the data
        if(h_count==height) begin
            //finish
        end
        
    
    end


    
    
endmodule

