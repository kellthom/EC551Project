from PIL import Image

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

input_image_path = 'path_to_your_input_image.jpg'  # Replace with your image path
output_file_path = 'grayscale_image_data.txt'      # Output file
image_to_grayscale_bytes_per_line(input_image_path, output_file_path)

def bytes_per_line_to_image(input_file_path, output_image_path, image_width, image_height):
    # Create an empty array for the image data
    img_data = np.empty((image_height, image_width), dtype=np.uint8)

    # Read the grayscale pixel values from the file
    with open(input_file_path, 'r') as file:
        for y in range(image_height):
            for x in range(image_width):
                # Read one line, convert from hex to integer
                pixel_value = int(file.readline().strip(), 16)
                img_data[y, x] = pixel_value

    # Convert the numpy array to an image
    image = Image.fromarray(img_data, 'L')

    # Save the image
    image.save(output_image_path)

input_file_path = 'grayscale_image_data.txt'  # Input file
output_image_path = 'reconstructed_image.jpg' # Where to save the reconstructed image
image_width = 640  # Replace with the actual width of the input image
image_height = 480 # Replace with the actual height of the input image
bytes_per_line_to_image(input_file_path, output_image_path, image_width, image_height)