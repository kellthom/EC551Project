# file_manager,py monitors a folder full of images.  When a new image is added, it translates the image into 3 mem files.
# Then it passes those files (and their dimensions) into a module that will eventually send them to the FPGA via uART.

import numpy as np
from prepreocess import *
from UART_IO import *
import time



#Global Variables
used_files=[]   #Needed to keep track of which files have been used




while(w==0):


    #Go through all possible files in the directory
    for i in range(100):

        #Here, the images folder is out working directory
        filename="images/image"+str(i)+'.jpg'

        #Open the file
        try:
            file=open(filename,"r")
        except:
            file=-1

        #Make sure it hasn't been used already
        try:
            contains=used_files.index(filename)
        except:
            contains=-1

        #If a file exists and hasn't been used already...
        if not(file==-1) and not(contains==-1):
            print()

            #Create the datafile
            output_file_path = 'rgb_image_data.txt'
            image_to_rgb_bytes(filename, output_file_path)

            #Pass it in
            uart_port = 'COM3'  # Replace with the UART port we are using
            input_file_path = 'rgb_image_data.txt' # Rename this to the file path of the image data we want to send to the FPGA
            output_file_path = 'fpga_image.hex' # Rename this to the file path of the image data we want to receive from the FPGA

            # Read the image data from the input file
            image_data = read_image_bytes_from_file(input_file_path)

            # Transmit the image data to the FPGA
            transmit_to_fpga(uart_port, image_data)

            # Assuming the FPGA sends back the same amount of data
            received_data = receive_from_fpga(uart_port, len(image_data))

            # Write the received data to the output file
            write_data_to_file(output_file_path, received_data)

            #Add to used_files
            used_files.append(filename)

            #Wait for processing to end
            time.sleep(3)
            
   


    









