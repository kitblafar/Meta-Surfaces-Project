# Functions used to add depth sensing imaging to the GUI
import tkinter as tk
from tkinter import ttk
import parallax
import cv2 as cv
import numpy as np
import HDR


class DepthPage(tk.Frame):
    def __init__(self, container):
        super().__init__(container)
        # define the left and right frames
        leftFrame = tk.Frame(container)
        leftFrame.grid(row=0, column=0, sticky=tk.NSEW)
        leftFrame.rowconfigure(0, weight=1)
        leftFrame.columnconfigure(0, weight=1)

        rightFrame = tk.Frame(container, bg='#f0f0f0')
        rightFrame.columnconfigure(0, weight=1)
        rightFrame.columnconfigure(0, weight=1)
        rightFrame.rowconfigure(0, weight=1)
        rightFrame.grid(row=0, column=1, sticky='nsew')

        # Display depth image in rightFrame
        self.slideImage = tk.Frame(rightFrame, bg='#f0f0f0')
        self.slideImage.rowconfigure(0, weight=5)
        self.slideImage.columnconfigure(0, weight=5)
        self.slideImage.grid(row=0, column=0, sticky='nsew')

        # Find the main image fileName
        self.filename = parallax.image_filename('depth', 1, 1)
        self.image = tk.PhotoImage(file='ParallaxAltered/' + self.filename)

        # main image
        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=0, column=0)

        # Create parallax parameters frame in the left frame
        parPar = tk.Frame(leftFrame)
        parPar.rowconfigure(0, weight=1)
        parPar.rowconfigure(1, weight=1)
        parPar.columnconfigure(0, weight=1)
        parPar.columnconfigure(1, weight=1)
        parPar.grid(row=0, column=0)

        # Example labels that serve as placeholders for other widgets
        ttk.Button(parPar, text="Inputs").grid(row=0, column=0, padx=5, pady=3, ipadx=10, sticky='s')
        ttk.Button(parPar, text="Viewing").grid(row=0, column=1, padx=5, pady=3, ipadx=10, sticky='s')

        # Example labels that could be displayed under the "Tool" menu
        tk.Label(parPar, text="File Location of Images").grid(row=1, column=0, padx=5, pady=5, sticky='n')
        tk.Entry(parPar).grid(row=1, column=1, padx=5, pady=5, sticky='n')
        container.tkraise()
        reconstruct_image()

def read_images(name):
    images = []
    if name =='depth' or name == 'par':
        size = parallax.mml_size('depth')
        # read images into an array
        for i in range(0, size):
            for j in range(0, size):
                filename = 'ParallaxAltered/' + parallax.image_filename('par', j + 1, i + 1)
                im = cv.imread(filename)
                images.append(im)
    elif name == 'HDR':
        size = parallax.mml_size('HDR')
        # read images into an array
        for i in range(0, size):
            for j in range(0, size):
                filename = 'HDRAltered/' + parallax.image_filename('HDR', j + 1, i + 1)
                im = cv.imread(filename)
                images.append(im)

    return images


# using cross-correlation to align these images as they do not have varying exposure/ absorption then combine into a
# full image
def reconstruct_image():
    # calculate shift between adjacent images then cut the images to these dimensions
    size = parallax.mml_size('depth')
    images = read_images('depth')
    newShift = np.zeros([size * size, 2])
    imagesAligned = []

    # Use translation
    # TODO have a go at homography as there is some warping due to the lens curvature (NOTE: requires a 3by3 translation matrix)
    warpMode = cv.MOTION_TRANSLATION

    # Define 2x3 or 3x3 matrices and initialize the matrix to identity
    warpMatrix = np.eye(2, 3, dtype=np.float32)

    # Specify the number of iterations.
    noIterations = 5000

    # Specify the threshold of the increment
    # in the correlation coefficient between two iterations
    increment = 1e-10

    # Define termination criteria
    criteria = (cv.TERM_CRITERIA_EPS | cv.TERM_CRITERIA_COUNT, noIterations, increment)

    # Run the ECC algorithm. The results are stored in warpMatrix. Do this on the first two images (11, 12) only to find the shift (constant for vertical and horizontal)
    imagesGray = cv.cvtColor(images[0], cv.COLOR_BGR2GRAY)
    imagesGray1 = cv.cvtColor(images[1], cv.COLOR_BGR2GRAY)
    (cc, warpMatrix) = cv.findTransformECC(imagesGray1, imagesGray, warpMatrix, warpMode, criteria)

    shift = warpMatrix[0, 2]

    # make list of new shifts
    for i in range(0, size):
        for j in range(0, size):
            newShift[i * size + j, 0] = -shift * -(j - int((size - 1) / 2))
            newShift[i * size + j, 1] = -shift * -(i - int((size - 1) / 2))


    # shift the image by the new shift values
    for i in range(0, size * size):
        print(shift[i])
        imagesAligned.append(HDR.shift_image(images[i], newShift[i]))
        cv.imshow('9th original', images[i])
        cv.waitKey(0)

    # return outputImage
    cv.imshow('9th images', imagesAligned[9])

def depth_calculate(images):
    stereo = cv.StereoBM_create(numDisparities=16, blockSize=15)
    disparity = stereo.compute(images[0], images[1])