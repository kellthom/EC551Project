from PIL import Image
import numpy as np


def bytes_per_line_to_image(input_file_path, output_image_path, image_width, image_height):
    # Create an empty array for the image data
    img_data = np.empty((image_height, image_width), dtype=np.uint8)

    # Read the grayscale pixel values from the file
    with open(input_file_path, 'r') as file:
        for x in range(image_height):
            for y in range(image_width):
                # Read one line, convert from hex to integer
                try:
                    pixel_value = int(file.readline().strip(), 16)
                except ValueError:
                    print(f'Error reading pixel at x={x}, y={y}')
                    print(f'Expected a hexadecimal integer, but got: {pixel_value}')
                    
                    
                img_data[x, y] = pixel_value

    # Convert the numpy array to an image
    image = Image.fromarray(img_data, 'L')

    # Save the image
    image.save(output_image_path)

input_file_path = 'received_data.hex'  # Input file
output_image_path = 'reconstructed_image.jpg' # Where to save the reconstructed image
image_width = 766  # Replace with the actual width of the input image
image_height = 510 # Replace with the actual height of the input image
bytes_per_line_to_image(input_file_path, output_image_path, image_width, image_height)