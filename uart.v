`timescale 1ns / 1ps


module uart(
    input clk,
    input rec,
    output reg[7:0] dout
    
    );
    
    //The number of clock cycles that pass during each bit transfer
    parameter cycles_per_bit=20;//10000000/115200;
    
    //3 States: 0 for awaiting data, 1 for sampling, 2 for holding
    integer state=0;
    
    //Count clock cycles
    integer counter=0;
    
    //data will be synced with dout once all data is collected
    reg[7:0] data;
    
    
    always@(posedge clk)begin
        
        //Awaiting transmission of start bit
        if (state==0) begin
            
            //Start bit detected
            if (rec==0) begin
                state=1;
            end
        
        //Reading bits in the middle 
        end else if(state==1) begin
            counter= counter+1;
            
            //Sample 0th bit
            if (counter==(3*cycles_per_bit/2)) begin
                data[0]=rec;
            end
            
            //Sample 1st bit
            if (counter==(5*cycles_per_bit/2)) begin
                data[1]=rec;
            end
            
            //Sample 2nd bit
            if (counter==(7*cycles_per_bit/2)) begin
                data[2]=rec;
            end
            
            //Sample 3rd bit
            if (counter==(9*cycles_per_bit/2)) begin
                data[3]=rec;
            end
            
            //Sample 4th bit
            if (counter==(11*cycles_per_bit/2)) begin
                data[4]=rec;
            end
            
            //Sample 5th bit
            if (counter==(13*cycles_per_bit/2)) begin
                data[5]=rec;
            end
            
            //Sample 6th bit
            if (counter==(15*cycles_per_bit/2)) begin
                data[6]=rec;
            end
            
            //Sample 7th bit
            if (counter==(17*cycles_per_bit/2)) begin
                data[7]=rec;
                dout=data;
                state=2;
            end
            
        //Holding
        end else if (state==2) begin
            counter= counter+1;
            
            //Start bit, data bits, and end bit have all passed
            //Start over
            if (counter==cycles_per_bit*10) begin
                state=0;
                counter=0;
            end
               
        end
        
    end
    
    
    
    
    
endmodule
