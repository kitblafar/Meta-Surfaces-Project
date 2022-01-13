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
        self.filename = parallax.image_filename('depth', int((size - 1)/2), int((size - 1)/2))
        self.image = tk.PhotoImage(file='DepthAltered/' + self.filename)

        # main image
        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=0, column=0)
        depthMap = depth_calculate()
        cv.imshow('depthMap', depthMap)
        cv.waitKey(0)
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
    if name =='par':
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

    cv.imshow('dst', dst)
    cv.waitKey(0)
    return dst

def depth_calculate(baseline=3, focalLength=4):
    images = read_images('depth')
    size = parallax.mml_size('depth')
    # find the middle two images- from which depth is calculated (only 2 are needed)
    image1 = images[int((size * size - 1)/2)]
    image2 = images[int((size * size - 1) / 2 + 1)]


    # Set disparity parameters
    # Note: disparity range is tuned according to specific parameters obtained through trial and error.
    # allow users to tune
    win_size = 3
    min_disp = 60
    max_disp = 120  # min_disp * 9
    num_disp = max_disp - min_disp  # Needs to be divisible by 16
    num_disp = 16 * math.ceil(num_disp / 16)
    # Create Block matching object.
    stereo = cv.StereoSGBM_create(minDisparity=min_disp,
                                 numDisparities=num_disp,
                                 blockSize=3,
                                 uniquenessRatio=5,
                                 speckleWindowSize=5,
                                 speckleRange=5,
                                 disp12MaxDiff=1,
                                 P1=6*3*win_size**3,
                                 P2=8*3*win_size**3)
    # Compute disparity map
    print("\nComputing the disparity  map...")
    disparityMap = stereo.compute(image1, image2) + 1

    print(disparityMap.dtype)

    #convert the disparity map to the depth map
    # baseline is the distance between the centre of each mml in um (entered in GUI by user)
    # focal length is the focal length of the MML entered by user

    disparityMap = disparityMap.astype(np.float32)
    # Scaling down the disparity values and normalizing them
    disparityMap = (disparityMap / 16.0 - min_disp) / num_disp

    cv.imshow('dismap', disparityMap)
    depthMap = (baseline*focalLength)/(disparityMap)
    return depthMap


# segment the image
def segment(depthMap):
    size = parallax.mml_size('depth')
    selection = int((size-1)/2)
    filename = parallax.image_filename('depth', selection, selection)
    filename = 'DepthAltered/'+filename
    orImage = cv.imread(filename)

    image = cv.cvtColor(orImage, cv.COLOR_BGR2RGB)  # change to conventional channel order

    vecImage = image.reshape((-1, 3))  # reshape into a 2 dimensional vector (each row is a vector in 3D RGB space)

    vecImage = np.float32(vecImage)  # convert from unit8 to float 32

    # define criteria, number of clusters(K) and apply k-means()
    criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    noClusters = 10
    attempts = 10
    ret, label, center = cv.kmeans(vecImage, noClusters, None, criteria, attempts, cv.KMEANS_PP_CENTERS)

    center = np.uint8(center)  # convert back to unit8

    res = center[label.flatten()]
    segmentedImage = res.reshape(orImage.shape)  # change to conventional image shape
    segmentedImage = cv.cvtColor(segmentedImage, cv.COLOR_RGB2BGR)  # change to openCV channel order

    # draw contours onto each cluster image
    edges = cv.Canny(segmentedImage, 10, 100)
    contours, hierarchy = cv.findContours(edges, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)

    # write contours into a mask within which the depth is averaged and return both the segmented image and the average
    # depth map
    averageDepthMap = np.zeros(segmentedImage.shape, np.uint8)

    mask = np.zeros(segmentedImage.shape[:2], np.uint8)
    for i in range(0, len(contours)):
        contourArea = cv.contourArea(contours[i])
        if contourArea > 10:
            cv.drawContours(mask, contours, i, 255, -1)
            cv.imshow('mask', mask)
            smallDepthMap = cv.bitwise_and(depthMap, depthMap, mask=mask)
            cv.imshow('smallDepthMap', smallDepthMap)
            # find median of all non-zero values
            median = np.median(np.nonzero(smallDepthMap))
            # assign all non-zero values to the median value
            averageSmallDepthMap = smallDepthMap
            averageSmallDepthMap[np.nonzero(averageSmallDepthMap)] = median
            cv.imshow('averageSmallDepthMap', averageSmallDepthMap)
            averageDepthMap = np.add(averageDepthMap, averageSmallDepthMap)
            cv.imshow('averageDepthMap', averageDepthMap)
            cv.waitKey(0)

    return averageDepthMap
