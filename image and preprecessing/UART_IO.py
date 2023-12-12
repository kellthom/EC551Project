import serial
import threading


# Function to read the image bytes from a text file
def read_image_bytes_from_file(file_path):
    with open(file_path, 'r') as file:
        byte_data = bytearray(int(line.strip(), 16) for line in file if line.strip())
    return byte_data

# Function to write data to a file
def write_data_to_file(file_path, data):
    with open(file_path, 'w') as file:  # Note the change to 'w' for writing text
        for byte in data:
            # Write each byte as hex in a new line
            file.write(f'{byte:02x}\n')  # Formats byte to 2-digit hex
        print(f"Data written to {file_path}")



# ###############################################################################################################################

# # Define UART port and file paths
uart_port = 'COM7'  # Replace with the UART port we are using
baud_rate = 1145000  # Replace with the baud rate we are using
input_file_path = 'rgb_image_data.txt' # Rename this to the file path of the image data we want to send to the FPGA
output_file_path = 'fpga_image.hex' # Rename this to the file path of the image data we want to receive from the FPGA

# ###############################################################################################################################


# Shared Serial Object
ser = serial.Serial(uart_port, baudrate=baud_rate, timeout=3000)

def transmit_to_fpga(image_data):
    global ser
    ser.write(image_data)
    print("Data transmitted to FPGA.")

def receive_from_fpga(data_size):
    global ser
    received_data = ser.read(data_size)
    print("Data received from FPGA.")
    
    write_data_to_file(output_file_path, received_data)
    return received_data


# Read the image data from the input file
image_data = read_image_bytes_from_file(input_file_path)

data_size = min(len(image_data), 512 * 768)

# Create and start threads
transmit_thread = threading.Thread(target=transmit_to_fpga, args=(image_data,))
receive_thread = threading.Thread(target=receive_from_fpga, args=(data_size,))

transmit_thread.start()
receive_thread.start()

transmit_thread.join()
receive_thread.join()

ser.close()