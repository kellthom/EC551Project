`timescale 1ns / 1ps


module create_serial(
    input clk,
    output reg[7:0] out,
    output reg eof
    );
    
    integer count=0;
    reg new_row; //Keep track of when a new row has been started
    reg [7:0] data; //8 bit data per pixel
    reg newfile; //Send a pulse each time a new file is started
    
    
    integer filer,fileg,fileb,testr,testg,testb; //Needed for fopen and fscanf
    integer counter; //Keep track of how many pixels have been passed
    
    //First open the file
    initial begin
        filer = $fopen("densmore_r.mem","r");
        fileg = $fopen("densmore_g.mem","r");
        fileb = $fopen("densmore_b.mem","r");
        eof=0;
        newfile=1;
    end
    
    always@(posedge clk) begin
        
        if (count%3==0) begin
            testr = $fscanf(filer,"%h",data); //Take the next value to be passed
        end
        if (count%3==1) begin
            testg = $fscanf(fileg,"%h",data);
        end
        if (count%3==2) begin
            testb = $fscanf(fileb,"%h",data);
        end
        
        //If there is no value, we have reached the end of the file
        if(testr==-1) begin
            $fclose(filer);
            eof = 1;
            newfile=0;
        end    
        
        
        //Set the output to the data captured from the file.
        //The rate of the serial input is determined by the clock period
        out=data;
        newfile=0;
        count=count+1;
    
    end
    
    
    
    
    
endmodule
