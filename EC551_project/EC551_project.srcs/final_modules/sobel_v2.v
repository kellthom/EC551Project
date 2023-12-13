`timescale 1ns / 1ps

module sobel_v2 #(parameter BAUD_VAL = 9)
 (
        input clk,
        input rstn,
        input start,
        input [7:0] data0,
        output wire[15:0] W_read  ,
        output wire[15:0] H_read ,
        output reg [7:0]data_out,
        output reg ready,
        output reg transmit_valid,
        output reg matrix_ready,
        input [15:0]H,
        input [15:0]W 

    );    
    reg [15:0]W_counter=0;
    reg [15:0]H_counter=0;
    reg [7:0]data[0:3][0:3];
    reg [2:0]W_counter2=0;
    reg [2:0]H_counter2=0;     
    reg signed[15:0]   Gx = 0,
                       Gy = 0;

    reg final = 0;

    integer count = 0;
    assign H_read = H_counter + H_counter2;
    assign W_read = W_counter + W_counter2;

    always @(posedge clk) begin
        if(rstn) begin
            W_counter <=0;
            H_counter <= 0; 
            ready  <= 0;
            count = 0;
            final <= 0;
            transmit_valid = 1'b0;
            W_counter2<=0;
            H_counter2<=0;
            matrix_ready  <= 0;
        end else begin
            count = count + 1;
            if(start && !ready && (count >= 12 * BAUD_VAL)) begin
            count = 0;
            data_out = Gx + Gy;   
//            if(H_counter==44 &W_counter==90) begin
//                $display("H_counter=%d",H_counter);
//                $display("W_counter=%d",W_counter);
//                $display("H_counter2=%d",H_counter2);
//                $display("W_counter2=%d",W_counter2);
//                $display("H_read=%d",H_read);
//                $display("W_read=%d",W_read);
//                $display("data=",data0);
////                $display("transmit_valid=%d",transmit_valid);
//                $display("-----------------------------------------------------");

//                end
//             if(H_counter==44 &W_counter==90 & H_counter2==2&  W_counter2==2) begin
//                $display("data0=%h",data[0][0]);
//                $display("data1=%h",data[0][1]);
//                $display("data2=%h",data[0][2]);
//                $display("data3=%h",data[1][0]);
//                $display("data4=%h",data[1][1]);
//                $display("data5=%h",data[1][2]);
//                $display("data6=%h",data[2][0]);
//                $display("data7=%h",data[2][1]);
//                $display("data8=%h",data[2][2]);
//                $display("data_out=%h",data_out);
//                $display("transmit_valid=%d",transmit_valid);
//                $display("-----------------------------------------------------");
//                $stop;
//                end

    //            if (Gx + Gy > 8'd200) begin
    //                data_out = 8'd255;
    //            end else begin
    //                data_out = 8'd0;
    //            end

//                transmit_valid = 1'b1;
                data[H_counter2][W_counter2] <= data0;
//                $display("display:\n");
//                $display("W_counter2 = %d",W_counter2);
//                $display("H_counter2 = %d",H_counter2);           

                if(W_counter2 != 2) begin
                    W_counter2 <= W_counter2 + 1;             
                end

                else begin
                    W_counter2 <= 0;
                    H_counter2 <= H_counter2 + 1;
                end


                if(W_counter2 == 2    &&   H_counter2 == 2)
                begin
                    W_counter2<=0;
                    H_counter2<=0;
                    transmit_valid = 1;
//                    if(W_counter>300 & W_counter<305 & H_counter>80 & H_counter<85)
//                    begin
//                    $display("W_counter= %d",W_counter);
//                    $display("H_counter= %d",H_counter);
//                    $display("sobelout= %h ",data_out);
//                    $display("data0= %h ",data[0][0]);
//                    $display("data1= %h ",data[0][1]);
//                    $display("data2= %h ",data[0][2]);
//                    $display("data3= %h ",data[1][0]);
//                    $display("data4= %h ",data[1][1]);
//                    $display("data5= %h ",data[1][2]);
//                    $display("data6= %h ",data[2][0]);
//                    $display("data7= %h ",data[2][1]);
//                    $display("data8= %h ",data[2][1]);
//                    $display("-----------------------------------------------");
//                    end


                    if(W_counter != W-1-2) begin
                        W_counter = W_counter + 1;              
                    end else begin
                        W_counter = 0;
                        H_counter = H_counter + 1;
                    end
                    if(W_counter == W-1-2    &&   H_counter == H-1-2) begin
                        ready <= 1;
                    end

                end
                else
                begin
                     transmit_valid = 0;
                end 
            end
            else begin
                transmit_valid = 1'b0;
            end

        end
    end


//    always @(posedge clk) begin
//    if(rstn ) begin
//        W_counter2<=0;
//        H_counter2<=0;
//        matrix_ready  <= 0;
//    end


//    else begin
////        $display("grayinput= ",data0);
//        if(start && !ready && (count >= 12 * BAUD_VAL) && (first_time >= 5)) begin
//            data[H_counter2][W_counter2] <= data0;
//            $display("display:\n");
//            $display("W_counter2 = %d",W_counter2);
//            $display("H_counter2 = %d",H_counter2);           

//            if(W_counter2 != 2) begin
//                W_counter2 <= W_counter2 + 1;             
//            end

//            else begin
//                W_counter2 <= 0;
//                H_counter2 <= H_counter2 + 1;
//            end


//            if(W_counter2 == 2    &&   H_counter2 == 2) begin
//                W_counter2<=0;
//                H_counter2<=0;
//                matrix_ready <= 1;
//                $display("matrix is ready");
//                $display("Sobel out= %h",data0);
////                $display("Sobel= ",data[H_counter2][W_counter2]);
//            end
//            else begin
//                matrix_ready <= 0;
//            end

//        end


//    end
//end

    always @(posedge clk && start) begin

        Gx =    -data[0][0] + data[2][0]          +
                 -2*data[0][1] + 2*data[2][1]  +
                 -data[0][2] + data0     ;

        Gy =   -data[0][0] - 2*data[1][0] - data[2][0]      +
                 data[0][2] + 2*data[1][2] + data0  ;
//        if(transmit_valid==1)begin

//                    if(H_counter<2)
//                    begin
//                    $display("W_counter= %d",W_counter);
//                    $display("H_counter= %d",H_counter);
////                    $display("W_counter2= %d",W_counter2);
////                    $display("H_counter2= %d",H_counter2);
//                    $display("sobelout= %h ",data_out);
////                    $display("data0= %h ",data[0][0]);
////                    $display("data1= %h ",data[0][1]);
////                    $display("data2= %h ",data[0][2]);
////                    $display("data3= %h ",data[1][0]);
////                    $display("data4= %h ",data[1][1]);
////                    $display("data5= %h ",data[1][2]);
////                    $display("data6= %h ",data[2][0]);
////                    $display("data7= %h ",data[2][1]);
////                    $display("data8= %h ",data0);
//                    $display("-----------------------------------------------");
//                    end
//        end
    end



endmodule