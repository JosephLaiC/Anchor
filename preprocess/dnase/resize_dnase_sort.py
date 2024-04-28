import numpy as np
import cv2
import os
import sys

# Define the input and output paths for the files
# path1 is the input path where the original files are located
# path2 is the output path where the processed files will be saved
# The input path is obtained from the first command-line argument
# The output path is obtained from the second command-line argument
path1 = sys.argv[1] # input
path2 = sys.argv[2] # output

# Create the output directory if it doesn't exist
os.system('mkdir -p ' + path2)

# Get a list of all the files in the input directory
all_files = os.listdir(path1)

# Loop through each file in the input directory
for the_file in all_files:
    # Print the name of the current file being processed
    print(the_file)

    # Load the current file as a numpy array
    x = np.loadtxt(path1 + the_file)

    # Resize the numpy array using OpenCV's cv2.resize function
    # The resized array is stored in the variable y
    # The resizing is done with the interpolation method cv2.INTER_AREA
    y = cv2.resize(x,(1,3036304),interpolation=cv2.INTER_AREA)

    # Round the values in the resized array to the nearest integer
    y = np.rint(y)

    # Save the processed array to a file in the output directory
    # The file is saved with the same name as the original file
    np.savetxt(path2 + the_file,y,fmt='%d')
