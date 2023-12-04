from PIL import Image
import numpy as np

def image_to_grayscale_bytes(input_image_path, output_file_path):
    # Load the image
    with Image.open(input_image_path) as img:
        # Convert image to grayscale
        grayscale_img = img.convert("L")

        # Convert grayscale image to numpy array
        img_array = np.array(grayscale_img)

        # Get height and width
        height, width = img_array.shape

        # Write height, width, and image data to file
        with open(output_file_path, 'wb') as file:
            file.write(height.to_bytes(2, byteorder='big'))
            file.write(width.to_bytes(2, byteorder='big'))
            img_array.tofile(file)

input_image_path = 'iguana.jpg'  # Replace with your image path
output_file_path = 'gray.hex'      # Output file
image_to_grayscale_bytes(input_image_path, output_file_path)



# def bytes_to_image(input_file_path, output_image_path):
#     with open(input_file_path, 'rb') as file:
#         # Read height and width from the first 4 bytes
#         height = int.from_bytes(file.read(2), 'big')
#         width = int.from_bytes(file.read(2), 'big')

#         # Read the rest of the file as image data
#         img_data = np.fromfile(file, dtype=np.uint8)

#         # Reshape data into image dimensions
#         img_data = img_data.reshape((height, width))

#         # Convert numpy array to image
#         image = Image.fromarray(img_data, 'L')

#         # Save the image
#         image.save(output_image_path)

# input_file_path = 'grayscale_image_data.bin'   # Input file
# output_image_path = 'reconstructed_image.jpg'  # Where to save the reconstructed image
# bytes_to_image(input_file_path, output_image_path)