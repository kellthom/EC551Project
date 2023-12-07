import cv2
import numpy as np

# Load an image
image = cv2.imread('tiger.jpg', cv2.IMREAD_GRAYSCALE)

# Check if image is loaded properly
if image is None:
    print("Could not open or find the image")
else:
    # Apply Sobel Edge Detection
    sobelx = cv2.Sobel(image, cv2.CV_64F, 1, 0, ksize=3)  # Sobel Edge Detection on the X axis
    sobely = cv2.Sobel(image, cv2.CV_64F, 0, 1, ksize=3)  # Sobel Edge Detection on the Y axis

    # # Display original image
    # cv2.imshow('Original', image)

     


    # # Display the Sobel X
    # cv2.imshow('Sobel X', sobelx)

    # # Display the Sobel Y
    # cv2.imshow('Sobel Y', sobely)

    # Combine X and Y
    sobel_combined = cv2.bitwise_or(sobelx, sobely)
    
    _, thresholded = cv2.threshold(sobel_combined, 200, 255, cv2.THRESH_BINARY)
    cv2.imshow('Sobel Combined', sobel_combined)

    cv2.imshow('Thresholded', thresholded)

    edges = cv2.Canny(image, threshold1=100, threshold2=200)

    # Display the edges
    cv2.imshow('Canny Edges', edges)



    cv2.waitKey(0)
    cv2.destroyAllWindows()
