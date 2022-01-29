# Functions used to add depth sensing imaging to the GUI
import tkinter as tk
from tkinter import ttk
import parallax
import cv2 as cv
import matplotlib.pyplot as plt
import numpy as np
import math


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

        # Display depth image on clickable canvas
        self.slideImage = tk.Frame(rightFrame, bg='#f0f0f0')
        self.slideImage.rowconfigure(0, weight=5)
        self.slideImage.columnconfigure(0, weight=5)
        self.slideImage.grid(row=0, column=0, sticky='nsew')

        # Find the main image fileName
        size = parallax.mml_size('depth')
        self.filename = parallax.image_filename('depth', int((size - 1) / 2), int((size - 1) / 2))
        self.image = tk.PhotoImage(file='DepthAltered/' + self.filename)

        # main image
        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=0, column=0)
        depthMap = depth_calculate()
        self.averageDepthMap = segment(depthMap)
        self.mainIm.bind("<B1-Motion>", self.show_depth)

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
        tk.Label(parPar, text="Distance(um) Between MML Centres").grid(row=1, column=0, padx=5, pady=5, sticky='n')
        tk.Entry(parPar).grid(row=1, column=1, padx=5, pady=5, sticky='n')
        tk.Label(parPar, text="Focal Length (um)").grid(row=1, column=0, padx=5, pady=5, sticky='n')
        tk.Entry(parPar).grid(row=1, column=1, padx=5, pady=5, sticky='n')
        container.tkraise()

    # return the selection from the average depth map
    def show_depth(self, event):
        x1, y1 = event.x, event.y
        depth = self.averageDepthMap[x1, y1]
        print(depth)


def read_images(name):
    images = []
    if name == 'par':
        size = parallax.mml_size('par')
        # read images into an array
        for i in range(0, size):
            for j in range(0, size):
                filename = 'ParallaxAltered/' + parallax.image_filename('par', j + 1, i + 1)
                im = cv.imread(filename)
                images.append(im)
    elif name == 'depth':
        size = parallax.mml_size('depth')
        # read images into an array
        for i in range(0, size):
            for j in range(0, size):
                filename = 'DepthAltered/' + parallax.image_filename('depth', j + 1, i + 1)
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


# function to remove barrel distortion on the image
def remove_barrel(image):
    width = image.shape[1]
    height = image.shape[0]

    distCoeff = np.zeros((4, 1), np.float64)
    # TODO: add your coefficients here!
    k1 = -2.0e-4  # negative to remove barrel distortion
    k2 = 0.0
    p1 = 0.0
    p2 = 0.0

    distCoeff[0, 0] = k1
    distCoeff[1, 0] = k2
    distCoeff[2, 0] = p1
    distCoeff[3, 0] = p2

    # assume unit matrix for camera
    cam = np.eye(3, dtype=np.float32)

    cam[0, 2] = width / 2.0  # define center x
    cam[1, 2] = height / 2.0  # define center y
    cam[0, 0] = 10.  # define focal length x
    cam[1, 1] = 10.  # define focal length y

    # here the undistortion will be computed
    dst = cv.undistort(image, cam, distCoeff)

    # cv.imshow('dst', dst)
    # cv.waitKey(0)
    return dst


# buffer for trackbars
def nothing(nothing):
    i = 1


def depth_calculate(baseline=3, focalLength=4):
    images = read_images('depth')
    size = parallax.mml_size('depth')
    # find the middle two images- from which depth is calculated (only 2 are needed)
    image1 = images[int((size * size - 1) / 2)]
    image2 = images[int((size * size - 1) / 2 + 1)]

    #median filter to remove drop pixels
    image1 = cv.medianBlur(image1, 3)
    image2 = cv.medianBlur(image2, 3)

    # Set disparity parameters
    # Note: disparity range is tuned according to specific parameters obtained through trial and error.
    # allow users to tune
    # Create Block matching object.
    minDisparity = 0
    numDisparities = 50
    stereo = cv.StereoSGBM_create(numDisparities=numDisparities,
                                  blockSize=5,
                                  P1=8*3*5*5,
                                  P2=32*3*5*5,
                                  preFilterCap=31,
                                  uniquenessRatio=10,
                                  speckleRange=0,
                                  speckleWindowSize=0,
                                  disp12MaxDiff=0,
                                  minDisparity=minDisparity,
                                  mode=1)
    # Compute disparity map
    print("\nComputing the disparity  map...")
    disparityMap = stereo.compute(image1, image2) + 1

    print(disparityMap.dtype)

    # convert the disparity map to the depth map
    # baseline is the distance between the centre of each mml in um (entered in GUI by user)
    # focal length is the focal length of the MML entered by user

    disparityMap = disparityMap.astype(np.float32)
    # Scaling down the disparity values and normalizing them
    disparityMap = (disparityMap / 16.0 - minDisparity) / numDisparities
    #
    # #apply heavy median filtering to remove all the speckling
    # disparityMap = cv.medianBlur(disparityMap, 7)

    cv.imshow('image1', image1)
    cv.imshow('dismap', disparityMap)
    depthMap = (baseline * focalLength) / disparityMap
    cv.imshow('depth', depthMap)
    cv.waitKey(0)
    return depthMap


# segment the image
def segment(depthMap):
    size = parallax.mml_size('depth')
    selection = int((size - 1) / 2)
    filename = parallax.image_filename('depth', selection, selection)
    filename = 'DepthAltered/' + filename
    orImage = cv.imread(filename)

    # median filter the image to remove non essential fine details
    median = cv.medianBlur(orImage, 3)

    # resharpen
    kernel = np.array([[0, -1, 0],
                       [-1, 5, -1],
                       [0, -1, 0]])
    sharp = cv.filter2D(src=median, ddepth=-1, kernel=kernel)

    # draw contours onto image
    # make image grey scale
    imgray = cv.cvtColor(sharp, cv.COLOR_BGR2GRAY)
    # Find Canny edges
    edged = cv.Canny(imgray, 190, 200)

    # dilate the image to join the contours
    kernel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (3, 3))
    dilated = cv.dilate(edged, kernel)
    contours, hierarchy = cv.findContours(dilated.copy(), cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)

    for index in range(0, len(contours)):
        colour = np.random.randint(0, 255, size=(3,))

        # convert data types int64 to int
        colour = (int(colour[0]), int(colour[1]), int(colour[2]))
        print(colour)
        cv.drawContours(sharp, contours, index, colour, cv.FILLED, 8, hierarchy)

    # # write contours into a mask within which the depth is averaged and return both the segmented image and the average
    # # depth map
    # averageDepthMap = np.zeros(orImage.shape, np.uint8)
    #
    # mask = np.zeros(orImage.shape[:2], np.uint8)
    # for i in range(0, len(contours)):
    #     contourArea = cv.contourArea(contours[i])
    #     if contourArea > 10:
    #         cv.drawContours(mask, contours, i, 255, -1)
    #         cv.imshow('mask', mask)
    #         smallDepthMap = cv.bitwise_and(depthMap, depthMap, mask=mask)
    #         cv.imshow('smallDepthMap', smallDepthMap)
    #         # find median of all non-zero values
    #         median = np.median(np.nonzero(smallDepthMap))
    #         # assign all non-zero values to the median value
    #         averageSmallDepthMap = smallDepthMap
    #         averageSmallDepthMap[np.nonzero(averageSmallDepthMap)] = median
    #         cv.imshow('averageSmallDepthMap', averageSmallDepthMap)
    #         averageDepthMap = np.add(averageDepthMap, averageSmallDepthMap)
    #         cv.imshow('averageDepthMap', averageDepthMap)
    #         cv.waitKey(0)

    return averageDepthMap
