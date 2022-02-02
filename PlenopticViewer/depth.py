# Functions used to add depth sensing imaging to the GUI
import tkinter as tk
from tkinter import ttk

import HDR
import parallax
from PIL import Image, ImageTk
import cv2 as cv
import numpy as np


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

        # Find the main image fileName (middle image of the micro lens array)
        size = parallax.mml_size('par')
        self.filename = 'ParallaxAltered/' + parallax.image_filename('depth', int((size + 1) / 2), int((size + 1) / 2))


        # main image
        depthMap = depth_calculate()
        [sharp, averageValues, fullContours] = segment(depthMap, cv.imread(self.filename))
        # make image displayable in tkinter
        sharp = cv.cvtColor(sharp, cv.COLOR_BGR2RGB)
        sharp = Image.fromarray(sharp)
        self.image = ImageTk.PhotoImage(image=sharp)

        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=0, column=0)
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


def read_images(name, mode='normal'):
    images = np.zeros((3, 3, 1000, 1000, 3), dtype=np.uint8)
    groupname = 'blank'
    directory = 'blank'
    MMLsize = 0
    if mode == 'init':
        if name == 'par' or name == 'depth':
            image = cv.imread('NewCamera/threemonkeys.png')
            images = parallax.images_seperate(image)
        elif name == 'cal':
            image = cv.imread('NewCamera/calibration.png')
            images = parallax.images_seperate(image)
        elif name == 'HDR':
            MMLsize = parallax.mml_size('HDR')
            testIm = cv.imread('Absorption/HDR_11.png')
            imageSize = testIm.shape[0]
            images = np.zeros((MMLsize, MMLsize, imageSize, imageSize, 3), dtype=np.uint8)
            # read images into an array
            for i in range(0, MMLsize):
                for j in range(0, MMLsize):
                    filename = 'Absorption/' + parallax.image_filename('HDR', j + 1, i + 1)
                    image = cv.imread(filename)
                    image = cv.flip(image, 0)
                    images[i, j] = image
    else:
        imageSize = 500  # all images are resized to this value for displaying
        if name == 'par' or name == 'depth':
            MMLsize = parallax.mml_size('par')
            directory = 'ParallaxAltered/'
            groupname = 'par'

        elif name == 'cal':
            MMLsize = parallax.mml_size('par')
            directory = 'CalibrationAltered/'
            groupname = 'cal'
        elif name == 'HDR':
            MMLsize = parallax.mml_size('HDR')
            directory = 'HDRAltered/'
            groupname = 'HDR'

        images = np.zeros((MMLsize, MMLsize, imageSize, imageSize, 3), dtype=np.uint8)
        # read images into an array
        for i in range(0, MMLsize):
            for j in range(0, MMLsize):
                filename = directory + parallax.image_filename(groupname, j + 1, i + 1)
                im = cv.imread(filename)
                images[i, j] = im

    return images


# function to calibrate the camera and remove associated distortion
def camera_calibrate():
    # termination criteria
    criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, 30, 0.001)
    # prepare object points, like (0,0,0), (1,0,0), (2,0,0) ....,(6,5,0)
    objp = np.zeros((7 * 7, 3), np.float32)
    objp[:, :2] = np.mgrid[0:7, 0:7].T.reshape(-1, 2)
    # Arrays to store object points and image points from all the images.
    objpoints = []  # 3d point in real world space
    imgpoints = []  # 2d points in image plane.
    images = read_images('cal')

    size = images.shape[0]
    print(size)

    for i in range(0, size):
        for j in range(0, size):
            img = images[i, j]
            gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
            # Find the chess board corners
            ret, corners = cv.findChessboardCorners(gray, (7, 7), None)
            # If found, add object points, image points (after refining them)
            if ret == True:
                objpoints.append(objp)
                corners2 = cv.cornerSubPix(gray, corners, (7, 7), (-1, -1), criteria)
                imgpoints.append(corners)
                # Draw and display the corners
                cv.drawChessboardCorners(img, (7, 7), corners2, ret)
                # cv.imshow('img', img)
                # cv.waitKey(0)

    # find the points necessary for camera callibration
    ret, mtx, dist, rvecs, tvecs = cv.calibrateCamera(objpoints, imgpoints, gray.shape[::-1], None, None)

    # read the required set of images (the parallax set for this application
    imgArray = read_images('par')
    for i in range(0, size):
        for j in range(0, size):
            img = imgArray[i, j]
            h, w = img.shape[:2]
            newcameramtx, roi = cv.getOptimalNewCameraMatrix(mtx, dist, (w, h), 1, (w, h))

            # undistort
            mapx, mapy = cv.initUndistortRectifyMap(mtx, dist, None, newcameramtx, (w, h), 5)
            dst = cv.remap(img, mapx, mapy, cv.INTER_LINEAR)
            # crop the image
            x, y, w, h = roi
            x = x + 10
            y = y + 10
            # print('x :',x, ' y:  ',y, ' w: ',w, ' h: ',h)
            dst = dst[y:y + h - 10, x:x + w - 10]
            # resize the altered image to 500 pixels squared
            dst = cv.resize(dst, (500, 500))
            filename = 'ParallaxAltered/' + parallax.image_filename('par', j + 1, i + 1)
            cv.imwrite(filename, dst)
            # cv.imshow('undistort', dst)
            # cv.waitKey(0)


def depth_calculate(baseline=0.05, focalLength=4, apSize=5):
    images = read_images('depth')
    imageSize = images[1, 1].shape[0]
    size = parallax.mml_size('depth')
    # find the middle three images- from which depth is calculated (only 2 are needed)
    image1 = images[int(size / 2), int(size / 2)]
    image2 = images[int(size / 2) + 1, int(size / 2)]
    image3 = images[int(size / 2) - 1, int(size / 2)]

    # #median filter to remove drop pixels
    # image1 = cv.medianBlur(image1, 3)
    # image2 = cv.medianBlur(image2, 3)

    # sharpen image
    kernel = np.array([[-1, -1, -1], [-1, 9, -1], [-1, -1, -1]])
    image1 = cv.filter2D(image1, -1, kernel)
    image2 = cv.filter2D(image2, -1, kernel)
    image3 = cv.filter2D(image3, -1, kernel)

    # cv.waitKey(0)

    # Set disparity parameters
    # Note: disparity range is tuned according to specific parameters obtained through trial and error.
    # allow users to tune
    # Create Block matching object.
    minDisparity = 0
    [a, horShift, b] = HDR.align_images('par')
    numDisparities = abs(int(horShift))  # use the shift calculated to align the images
    stereo = cv.StereoSGBM_create(numDisparities=numDisparities,
                                  blockSize=10,
                                  P1=8 * 3 * 5 * 5,
                                  P2=32 * 3 * 5 * 5,
                                  preFilterCap=10,
                                  uniquenessRatio=10,
                                  speckleRange=0,
                                  speckleWindowSize=0,
                                  disp12MaxDiff=0,
                                  minDisparity=minDisparity,
                                  mode=1)
    # Compute disparity map
    print("\nComputing the disparity  map...")
    disparityMap1 = stereo.compute(image3, image1)
    disparityMap2 = stereo.compute(image1, image2)

    # convert the disparity map to the depth map
    # baseline is the distance between the centre of each mml in um (entered in GUI by user)
    # focal length is the focal length of the MML entered by user

    disparityMap1 = disparityMap1.astype(np.float32)
    disparityMap2 = disparityMap2.astype(np.float32)

    # combine both dispartiy maps (average where the intersection is)
    fullDismap = np.zeros([imageSize, imageSize], dtype=np.float32)

    fullDismap[0:imageSize, 0:imageSize - numDisparities] = disparityMap1[0:imageSize, numDisparities:imageSize]
    fullDismap[0:imageSize, numDisparities:imageSize] = disparityMap2[0:imageSize, numDisparities:imageSize]

    # average the overlap
    fullDismap[0:imageSize, numDisparities:imageSize - numDisparities] = (fullDismap[0:imageSize,
                                                                          numDisparities:imageSize - numDisparities] + disparityMap1[
                                                                                                                       0:imageSize,
                                                                                                                       numDisparities * 2:imageSize]) * 0.5

    # replace all zero values with 17 ( this will scale down in the next step to a  (avoids divide by zero error)
    result = np.where(fullDismap < 17)
    listOfIndices = list(zip(result[0], result[1]))

    for i in range(0, len(listOfIndices)):
        fullDismap[listOfIndices[i]] = 17

    # Scaling down the disparity values and normalizing them
    fullDismap = (fullDismap / 16.0 - minDisparity) / numDisparities

    # cv.imshow('fulldismap', fullDismap)

    fullDepthMap = np.reciprocal(fullDismap)
    fullDepthMap = fullDepthMap * (baseline * focalLength)
    # cv.imshow('depth', fullDepthMap)
    # cv.waitKey(0)

    return fullDepthMap


# segment the image
def segment(depthMap, image):
    size = parallax.mml_size('depth')
    # median filter the image to remove non essential fine details
    median = cv.medianBlur(image, 5)

    # resharpen
    kernel = np.array([[0, -1, 0],
                       [-1, 5, -1],
                       [0, -1, 0]])
    sharp = cv.filter2D(src=median, ddepth=-1, kernel=kernel)

    # cv.imshow('sharp', sharp)
    averageValue = []
    fullcontours = []

    # find contours in image on each channel
    for i in range(0, sharp.shape[2]):
        # make image grey scale
        im = sharp[:, :, i]

        im = cv.medianBlur(im, 7)
        # Find Canny edges
        edged = cv.Canny(im, 0, 150, apertureSize=3, L2gradient=True)

        # dilate the image to join the contours
        kernel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (3, 3))
        dilated = cv.dilate(edged, kernel)

        contours, hierarchy = cv.findContours(dilated, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)

        # draw contours onto image on each channel
        for index in range(0, len(contours)):
            colour = np.random.randint(0, 255, size=(3,))
            mask = np.zeros((image.shape[0], image.shape[1]), np.uint8)
            # convert data types int64 to int
            colour = (int(colour[0]), int(colour[1]), int(colour[2]))
            cv.drawContours(sharp, contours, index, colour, 3)

            # create the mask
            cv.drawContours(mask, contours, index, (255, 255, 255), cv.FILLED, 8, hierarchy)
            # converting to its binary form
            _, mask = cv.threshold(mask, 1, 255, cv.THRESH_BINARY)

            noPoints = np.count_nonzero(mask)

            # average the depth map within the contours
            index = np.transpose(np.nonzero(mask))
            # print(index[1])
            sum = 0
            for i in range(0, len(index)):
                sum = sum + depthMap[index[i][0], index[i][1]]

            averageValue.append([sum / noPoints])
            fullcontours.append(contours)
            print(fullcontours)

    return sharp, averageValue, fullcontours
