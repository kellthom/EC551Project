# EC551Project



## How to generate input data for the testbenches and on board testing?
1. First, open the "image and preprocessing" folder.
2. Use preprocess.py to convert an image to a file containing the bytes
3. the file is called "rgb_image_data.txt" by default
4. This is the input file for the testbenches and on board testing
5. If you got a processed image from the testbenches, you can use reconstruct.py to rebuild the image from the bytes file



## How to run testbenches?

1. The testbenches are located at "EC551_project\EC551_project.srcs\", the folders are sim_1, sim_2, and sim_3
   1. Sim_1 is for testing the UART receiver and transmitter
   2. Sim_2 is for testing the grayscale sobel edge detection
   3. Sim_3 is for testing the RGB sobel edge detection, which is the most comprehensive testbench
2. To run the sim_3 testbench, you need to first generate the input file using the steps in "How to generate input data for the testbenches and on board testing?"
3. Then, place the input file in the working directory of the testbench
4. The received data will be saved as "received_data.hex" in the working directory of the testbench
5. The received data can be used to reconstruct the image using reconstruct.py in "image and preprocessing" folder


## How to do on board testing?

1. Configure the verilog codes correctly before start
   1. codes are in "EC551_project\EC551_project.srcs\sources_1\new"
   2. The top module is called "new_top" make sure to configure the IO correctly
   3. Go through the steps of Vivado, including synthesis, implementation, and generate bitstream
   4. Program the FPGA with the bitstream file
2. Follow the steps in "How to generate input data for the testbenches and on board testing?" to generate the input file
   1. Place the generated file in the same folder as the python script, UART_IO.py
   2. In UART_IO.py, remember to check the port number and baud rate to match the setting of FPGA and Verilog code
   3. Run the UART_IO.py to transmit the file to the FPGA
   4. The same script shall also be able to receive data from fpga
   5. If successful, the received data will be saved as "fpga_image.hex" in the same folder as the python script
   6. This can be used to reconstruct the image using reconstruct.py in "image and preprocessing" folder