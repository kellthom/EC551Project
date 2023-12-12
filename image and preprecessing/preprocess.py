from PIL import Image
import numpy as np

def image_to_grayscale_bytes_per_line(input_image_path, output_file_path):
    # Load the image
    with Image.open(input_image_path) as img:
        # Convert image to grayscale
        grayscale_img = img.convert("L")

        # Open the output file
        with open(output_file_path, 'w') as file:
            # Write grayscale pixel values, one per line in hexadecimal
            for pixel in list(grayscale_img.getdata()):
                file.write(f'{pixel:02x}\n')  # Write byte in hexadecimal format

input_image_path = 'iguana.jpg'
output_file_path = 'grayscale_image_data.txt'      # Output file
image_to_grayscale_bytes_per_line(input_image_path, output_file_path)

def image_to_rgb_bytes(input_image_path, output_file_path):
    # Load the image
    with Image.open(input_image_path) as img:
        # Convert image to RGB if not already
        rgb_img = img.convert("RGB")

        # Get image dimensions
        width, height = rgb_img.size

        # Open the output file
        with open(output_file_path, 'w') as file:
            # Write height and width in hexadecimal format, byte by byte
            file.write(f'{height >> 8:02x}\n')  # Higher byte of height
            file.write(f'{height & 0xFF:02x}\n')  # Lower byte of height
            file.write(f'{width >> 8:02x}\n')  # Higher byte of width
            file.write(f'{width & 0xFF:02x}\n')  # Lower byte of width

            # Write RGB pixel values, byte by byte
            for r, g, b in list(rgb_img.getdata()):
                file.write(f'{r:02x}\n')  # Red
                file.write(f'{g:02x}\n')  # Green
                file.write(f'{b:02x}\n')  # Blue


output_file_path = 'rgb_image_data.txt'      # Output file
image_to_rgb_bytes(input_image_path, output_file_path)