import serial
import time
from PIL import Image
import io
import numpy as np

    

def image_to_byte_array(image: Image):
    # data = io.BytesIO()
    # image.save(img_byte_arr, format='BMP')
    # data = img_byte_arr.getvalue()
    
    data = np.asarray(image)
    
    Width, Height = image.size
    
    print (np.shape(data))
    data.resize(Width * Height, 3)
    
    return Width, Height, data

def send_image_to_fpga(ser, image_path):
    img = Image.open(image_path)
    Width, Height, data = image_to_byte_array(img)

    # Sending image size first
    ser.write(Height.to_bytes(4, byteorder='big'))
    ser.write(Width.to_bytes(4, byteorder='big'))
    time.sleep(0.1)  # Small delay to ensure data is processed in order

    # Sending image data
    ser.write(data[0])
    ser.write(data[1])
    ser.write(data[2])
    
    return Width, Height

def receive_image_from_fpga(W, H, ser):
    # Read the size of the incoming image

    img_size = W * H * 3
    # Read the image data
    img_data = ser.read(img_size)
    if len(img_data) < img_size:
        print("Error: Incomplete image data received")
        return None

    # Convert byte array back to image
    img = Image.frombytes('RGB', (W, H), img_data)
    return img

# Setup UART communication
ser = serial.Serial('COM5', 500, timeout=1)  # Adjust port and baud rate as needed, BUAD rate must match the verilog code
time.sleep(2)  # Wait for the connection to establish

Width, Height = send_image_to_fpga(ser, 'example.jpg')



time.sleep(2)
processed_image = receive_image_from_fpga(ser, Width, Height)

if processed_image:
    processed_image.show()  # Display the image or save it as needed

ser.close()



# img = Image.open('example.jpg')
# Width, Height, data = image_to_byte_array(img)
# print(Width, Height)

# processed_image = Image.frombytes('RGB', (Width, Height), data)

# if processed_image:
#     processed_image.show()  # Display the image or save it as needed
    
