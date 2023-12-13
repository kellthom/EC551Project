import serial
import time
def read_from_port(ser, output_file):
    data_received = bytearray()
    
    while ser.in_waiting > 0:
        data = ser.read(ser.in_waiting)
        data_received.extend(data)
        output_file.write(data)
        print(data.decode('utf-8', errors='replace'), end='', flush=True)
    
    return data_received


def main():
    port = 'COM5'  # Replace with your COM port
    baud_rate = 115100  # Replace with the baud rate used by your FPGA
    output_file_path = 'fpga_output.txt'  # Output file path

    with serial.Serial(port, baud_rate, timeout=0) as ser, open(output_file_path, 'wb') as output_file:
            print("Type your message and press enter (type 'exit' to stop):")

            while True:
                # Check for incoming data before user input
                read_from_port(ser, output_file)

                # User input
                input_data = input()
                if input_data.lower() == 'exit':
                    break

                # Send data
                ser.write(input_data.encode('utf-8') + b'\n')

if __name__ == "__main__":
    main()
