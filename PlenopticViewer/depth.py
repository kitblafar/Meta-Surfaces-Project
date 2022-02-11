# Functions used to add depth sensing imaging to the GUI
import tkinter as tk
from tkinter import ttk
import HDR
import parallax
from PIL import Image, ImageTk
import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt


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
        filename = 'ParallaxAltered/' + parallax.image_filename('depth', int((size + 1) / 2), int((size + 1) / 2))

        self.depthMapOrg = depth_calculate()
        self.depthMap = self.depthMapOrg.copy()

        # main image
        self.originalIm = cv.imread(filename)

        # originally show the untouched image
        self.image = cv.cvtColor(self.originalIm, cv.COLOR_BGR2RGB)
        self.image = Image.fromarray(self.image)
        self.image = ImageTk.PhotoImage(image=self.image)

        self.heatmap = self.originalIm.copy()
        self.drawnContours = self.originalIm.copy()

        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=0, column=0)

        # define lists to be populated later
        self.masks = []
        self.ignoreMask = np.zeros(self.originalIm.shape, np.uint8)
        self.averageValues = []
        self.backgroundCord = []

        # Create depth parameters frame in the left frame
        parPar = tk.Frame(leftFrame)
        parPar.rowconfigure(0, weight=1)
        parPar.rowconfigure(1, weight=1)
        parPar.rowconfigure(2, weight=1)
        parPar.rowconfigure(3, weight=1)
        parPar.rowconfigure(4, weight=1)
        parPar.rowconfigure(5, weight=1)
        parPar.columnconfigure(0, weight=1)
        parPar.columnconfigure(1, weight=1)
        parPar.grid(row=0, column=0)

        # Example labels

        # TODO: Get focal length and distance between MML centres to be user inputs
        # Example labels that could be displayed under the "Tool" menu
        ttk.Button(parPar, text="Contour Image", command=lambda: self.update_mainimage('n')).grid(row=0,
                                                                                                  column=0,
                                                                                                  padx=5,
                                                                                                  pady=3,
                                                                                                  ipadx=10,
                                                                                                  sticky='s')
        ttk.Button(parPar, text="HeatMap View", command=lambda: self.update_mainimage('h')).grid(row=0, column=1,
                                                                                                 padx=5, pady=3,
                                                                                                 ipadx=10, sticky='s')

        tk.Label(parPar, text="Enter the Values Required").grid(row=1, column=0, padx=5, pady=5, sticky='n')

        tk.Label(parPar, text="Distance(um) Between MML Centres (Auto: 0.05)").grid(row=2, column=0, padx=5, pady=5,
                                                                                    sticky='n')
        self.distanceEnt = tk.Entry(parPar)
        self.distanceEnt.grid(row=2, column=1, padx=5, pady=5, sticky='n')
        self.distanceEnt.bind('<Return>', self.update_depthmap)
        tk.Label(parPar, text="Focal Length (um) (Auto: 4)").grid(row=3, column=0, padx=5, pady=5, sticky='n')
        self.focalEnt = tk.Entry(parPar)
        self.focalEnt.grid(row=3, column=1, padx=5, pady=5, sticky='n')
        self.focalEnt.bind('<Return>', self.update_depthmap)
        self.depthLabel = tk.Label(parPar, text='Double Click an Image Area to See Depth')
        self.depthLabel.grid(row=4, column=0, padx=5, pady=5, sticky='n')
        tk.Label(parPar, text="Click `Set Background` then Double Click the Image Background.").grid(row=5, column=0,
                                                                                                     padx=5, pady=5,
                                                                                                     sticky='n')
        ttk.Button(parPar, text="Set Background", command=self.rebind_canvas).grid(row=5, column=1, padx=5, pady=3,
                                                                                   ipadx=10, sticky='s')

        container.tkraise()

    def update_mainimage(self, name):
        print('image update called')
        # change the main image to the normal segmented image
        imageUpdate = self.originalIm
        if name == 'h':
            imageUpdate = cv.cvtColor(self.heatmap, cv.COLOR_BGR2RGB)
        elif name == 'n':
            imageUpdate = cv.cvtColor(self.drawnContours, cv.COLOR_BGR2RGB)

        imageUpdate = Image.fromarray(imageUpdate)
        self.image = ImageTk.PhotoImage(image=imageUpdate)
        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=0, column=0)

        print('image updated')

        # rebind the canvas to showing depth
        self.mainIm.bind('<Double-1>', self.show_depth)

    # to update the depthmap redefine the background
    def update_depthmap(self, _):
        baseline = self.distanceEnt.get()
        focalLength = self.focalEnt.get()

        if baseline == '' or focalLength == '':
            self.depthLabel = depth_calculate()
        else:
            self.depthMap = depth_calculate(baseline=float(baseline), focalLength=float(focalLength))

        self.update_segment()
        # cv.imshow('depthmap', self.depthMap)
        # cv.imshow('original', self.originalIm)
        # cv.waitKey(0)

    def rebind_canvas(self):
        print('rebound to update background')
        self.mainIm.bind('<Double-1>', self.update_background)
        self.mainIm.grid(row=0, column=0)

    def update_background(self, event):
        self.backgroundCord = [event.x, event.y]
        self.update_segment()

    # remove background
    def update_segment(self):
        print('update segment called')
        self.ignoreMask = []
        # apply contouring to image with background removed
        [self.drawnContours, self.averageValues, self.masks, self.ignoreMask] = segment(self.backgroundCord[1],
                                                                                        self.backgroundCord[0],
                                                                                        self.depthMapOrg,
                                                                                        self.originalIm.copy())
        # create the heatmap overlay
        self.heatmap = create_heatmap(self.masks, self.averageValues, self.ignoreMask)

        self.update_mainimage('n')

    # return the selection from the average depth map
    def show_depth(self, event):
        print('depth clicked')
        x1, y1 = event.x, event.y
        depth = return_average(x1, y1, self.averageValues, self.masks, self.ignoreMask)
        if depth == 0:
            text = 'Background Value Not Calculated'
        else:
            text = 'Depth: ' + str(depth) + '\u03BC' + 'm'
        self.depthLabel.config(text=text)


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


def depth_calculate(baseline=0.05, focalLength=4.22):
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
def segment(x, y, depthMap, image):
    # segment the image using k-cluster means
    # convert to RGB
    image = cv.cvtColor(image, cv.COLOR_BGR2RGB)

    # reshape the image to a 2D array of pixels and 3 color values (RGB)
    pixelValue = image.reshape((-1, 3))

    # convert to float
    pixelValue = np.float32(pixelValue)

    # define stopping criteria
    criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, 100, 0.2)

    # number of clusters (K)

    k = 5
    _, labels, (centers) = cv.kmeans(pixelValue, k, None, criteria, 10, cv.KMEANS_RANDOM_CENTERS)

    # convert back to 8 bit values
    centers = np.uint8(centers)
    # print(labels)
    # print(centers)

    # flatten the labels array
    labels = labels.flatten()

    # convert all pixels to the color of the centroids
    segmentedImage = centers[labels.flatten()]

    # reshape back to the original image dimension
    segmentedImage = segmentedImage.reshape(image.shape)

    # find the segment the user clicked on and remove it
    segment = segmentedImage[y, x].astype(np.float32)

    backgroundRemoved = np.copy(image)
    # convert to the shape of a vector of pixel values
    backgroundRemoved = backgroundRemoved.reshape((-1, 3))

    cluster = np.argwhere(centers == segment)
    ignore = cluster[0][0]

    ignoreMask = np.copy(backgroundRemoved)
    backgroundRemoved[labels == ignore] = [0, 0, 0]
    ignoreMask[labels == ignore] = [0, 0, 0]
    ignoreMask[labels != ignore] = [1, 1, 1]

    # convert back to original shape
    backgroundRemoved = backgroundRemoved.reshape(image.shape)
    backgroundRemoved = cv.cvtColor(backgroundRemoved, cv.COLOR_BGR2RGB)

    # convert back to original shape
    ignoreMask = ignoreMask.reshape(image.shape)

    drawnContours = backgroundRemoved

    clusteredImage = []
    blankCluster = np.zeros(image.shape, np.uint8)

    # separate each cluster and store as separate image
    for i in range(0, k):
        if i == ignore:  # skip the background cluster
            continue

        currClustIm = np.copy(blankCluster)
        # convert to the shape of a vector of pixel values
        currClustIm = currClustIm.reshape((-1, 3))

        cluster = i
        currClustIm[labels == cluster] = [255, 255, 255]

        # convert back to original shape
        currClustIm = currClustIm.reshape(image.shape)
        # # show the mask
        # cv.imshow('mask', currClustIm)
        # cv.waitKey(0)

        # append the mask to the mask array
        clusteredImage.append(currClustIm)

    averageValue = []
    masks = []

    # find contours in image on each clustered image (make a mask of each)
    for i in range(0, len(clusteredImage)):
        # make cluster image grey scale
        im = cv.cvtColor(clusteredImage[i], cv.COLOR_RGB2GRAY)

        # cv.imshow('cluster', im)
        # cv.waitKey(0)

        # find the contours on the clustered image
        contours, hierarchy = cv.findContours(im, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)

        # draw contours onto colour image and on each mask
        for j in range(0, len(contours)):
            colour = np.random.randint(0, 255, size=(3,))

            # define a blank mask
            mask = np.zeros((image.shape[0], image.shape[1]), np.uint8)

            # convert data types int64 to int
            colour = (int(colour[0]), int(colour[1]), int(colour[2]))
            cv.drawContours(drawnContours, contours, j, colour, 1)
            # cv.imshow('drawn', drawnContours)

            # create the mask
            cv.drawContours(mask, contours, j, (255, 255, 255), cv.FILLED)
            # cv.imshow('mask', mask)
            # cv.waitKey(0)

            # converting masks to its binary form
            mask = mask.astype(bool)

            noPoints = np.count_nonzero(mask)

            # average the depth map within the contours
            index = np.transpose(np.nonzero(mask))

            # print(index[1])
            sum = 0
            for i in range(0, len(index)):
                sum = sum + depthMap[index[i][0], index[i][1]]

            averageValue.append([sum / noPoints])
            masks.append(mask)

    return drawnContours, averageValue, masks, ignoreMask


def create_heatmap(masks, averageValues, ignoreMask):
    # multiple each mask by average values associated and combine into large greyscale image
    heatmap = np.zeros(masks[1].shape, np.uint8)
    maxAverageValue = max(averageValues)

    for i in range(0, len(averageValues)):
        # normalise the average value to 255 (greyscale)
        normalAverageValue = averageValues[i][0].astype(np.float) * 255.0 / float(maxAverageValue[0])

        averageMask = np.multiply(masks[i].astype(np.uint8), normalAverageValue.astype(np.uint8))

        print('average mask value ', np.max(averageMask[i]).astype(np.uint8))
        print('normal average value ', normalAverageValue)
        heatmap = np.add(heatmap, averageMask)
        # print('maximum mask value: ', np.max(masks[i]).astype(np.uint8))

    cv.imshow('mask * average values ' + str(i), heatmap)
    cv.waitKey(0)

    heatmap = cv.applyColorMap(heatmap, cv.COLORMAP_JET)
    cv.imshow('ignore mask: ', ignoreMask * 255)
    cv.waitKey(0)
    heatmap = np.multiply(heatmap, ignoreMask)  # remove the background again
    heatmap = cv.cvtColor(heatmap, cv.COLOR_RGB2BGR)
    cv.imshow('heatmap', heatmap)
    cv.waitKey(0)

    return heatmap


# return the average of the smallest contour within the set (most specific value)
# BACKGROUND VALUE AS YET INACCURATE (TELL USERS TO MAKE BACKGROUND DIFFERENT TO INSPECTED SHAPE)
def return_average(x, y, averageValues, masks, ignoreMask):
    depth = 0.0
    # print('coordinates: ', x , y)
    prevSum = masks[0].shape[0] + 1  # the maximum size the mask could be (all high) +1
    if ignoreMask[y][x][0] == 0:  # if in the background return depth is zero
        depth = 0.0
    else:
        for i in range(0, len(masks)):
            if masks[i][y, x] != 0:
                currSum = np.sum(masks[i], dtype=np.uint8)
                if prevSum > currSum:
                    depth = averageValues[i]  # if this is the smallest contour set depth to this
    print('depth', depth)
    return depth
