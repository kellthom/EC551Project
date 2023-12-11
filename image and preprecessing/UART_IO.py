import serial

# Function to transmit data to the FPGA
def transmit_to_fpga(port, image_data, baud_rate=9600):
    with serial.Serial(port, baud_rate) as ser:
        ser.write(image_data)
        print("Data transmitted to FPGA.")

# Function to receive data back from the FPGA
def receive_from_fpga(port, data_size, baud_rate=9600, timeout=10):
    with serial.Serial(port, baud_rate, timeout=timeout) as ser:
        received_data = ser.read(data_size)
        print("Data received from FPGA.")
        return received_data

# Function to read the image bytes from a text file
def read_image_bytes_from_file(file_path):
    with open(file_path, 'r') as file:
        byte_data = bytearray(int(line.strip(), 16) for line in file if line.strip())
    return byte_data

# Function to write data to a file
def write_data_to_file(file_path, data):
    with open(file_path, 'wb') as file:
        file.write(data)
        print(f"Data written to {file_path}")

###############################################################################################################################

# Define UART port and file paths
uart_port = 'COM5'  # Replace with the UART port we are using
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
