# EC551Project


## How to do on board testing?

1. Configure the verilog codes correctly before start
   1. codes are in "EC551Project\EC551_project\EC551_project.srcs\sources_1\new"
   2. The top module is called "new_top" make sure to configure the IO correctly
2. First, open the "image and preprocessing" folder.
   1. Use preprocess.py to convert an image to a file containing the bytes
   2. the file is called "rgb_image_data.txt" by default
   3. Use UART_IO.py to transmit the file to the FPGA
   4. remember to check the port number and baud rate to match the setting of FPGA and Verilog code
   5. the same script shall also be able to receive data from fpga
   6. use reconstuct.py to rebuild the image from the byte file