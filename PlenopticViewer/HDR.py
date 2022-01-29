# Functions used to align images and perform HDR imaging
import tkinter as tk
from tkinter import ttk
import parallax
import cv2 as cv
import numpy as np
from PIL import Image, ImageTk
import depth


class HDRPage(tk.Frame):
    def __init__(self, container):
        super().__init__(container)
        self.imageSet = align_images()
        # define the left and right frames
        left_frame = tk.Frame(container)
        left_frame.grid(row=0, column=0, sticky=tk.NSEW)
        left_frame.rowconfigure(0, weight=1)
        left_frame.columnconfigure(0, weight=1)

        right_frame = tk.Frame(container, bg='#f0f0f0')
        right_frame.columnconfigure(0, weight=1)
        right_frame.columnconfigure(0, weight=1)
        right_frame.rowconfigure(0, weight=1)
        right_frame.grid(row=0, column=1, sticky='nsew')

        # Display HDR image in right_frame
        self.HDRImage = tk.Frame(right_frame, bg='#f0f0f0')
        self.HDRImage.rowconfigure(0, weight=5)
        self.HDRImage.columnconfigure(0, weight=5)
        self.HDRImage.grid(row=0, column=0, sticky='nsew')

        # Find the main image fileName
        self.filename = parallax.image_filename('HDR', 1, 1)
        self.image = HDR_combine(self.imageSet)

        # main image
        self.mainIm = tk.Label(self.HDRImage, image=self.image)
        self.mainIm.grid(row=0, column=0)

        # Create HDR parameters in the left frame
        parPar = tk.Frame(left_frame)
        parPar.grid(row=0, column=0)
        parPar.rowconfigure(0, weight=1)
        parPar.rowconfigure(1, weight=1)
        parPar.rowconfigure(2, weight=1)
        parPar.rowconfigure(3, weight=1)
        parPar.rowconfigure(4, weight=1)
        parPar.columnconfigure(0, weight=1)

        label1 = tk.Label(parPar, text="Maximum Absorption (between 5 and 30)")
        label1.grid(row=0, column=0, padx=5, pady=5, sticky='n')
        self.sl1 = ttk.Scale(parPar, from_=5, to=30, orient=tk.HORIZONTAL)
        self.sl1.bind('<ButtonRelease>', self.update_absorb)
        self.sl1.grid(row=1, column=0, sticky='NSEW')
        label2 = tk.Label(parPar, text="Minimum Absorption (between 0 and 2)")
        label2.grid(row=2, column=0)
        self.sl2 = ttk.Scale(parPar, from_=0, to=2, orient=tk.HORIZONTAL)
        self.sl2.bind('<ButtonRelease>', self.update_absorb)
        self.sl2.grid(row=3, column=0, sticky='NSEW')

    def update_absorb(self, number):
        maxAbs = self.sl1.get()
        print('Max Absorption='+str(maxAbs))
        minAbs = self.sl2.get()
        print('Min Absorption=' + str(minAbs))

        if minAbs == 0:
            minAbs = 0.001

        # update image
        self.imageSet = align_images()
        self.image = HDR_combine(self.imageSet, maxAbs, minAbs)
        self.mainIm = tk.Label(self.HDRImage, image=self.image)
        self.mainIm.grid(row=0, column=0)



"""find the overlap between two neighbouring images (with middle absorption= best chance of features) and remove 
overlap from all images (spiral) lens spacing and therefore overlap are constant between images """
# TODO stitch two images, stitched image length- original image length= cut-off
"""as the parallax is small (in reality), aligning using the expose align built into opencv should work"""

# align the images to a centre point
def align_images():
    imagesOutput = []
    images = []
    size = parallax.mml_size('HDR')
    shift = np.zeros([size, size, 2])  # 2D shift therefore two shift values for each MML
    vertShift = np.zeros([size*size, 1])
    horShift = np.zeros([size*size, 1])
    newShift = np.zeros([size*size, 2])
    horList = np.zeros([size, 1])
    vertList = np.zeros([size, 1])

    alignMTB = cv.createAlignMTB() # use open cv align med function to get estimate of shifts

    # read images into an array
    arrayImages = depth.read_images('HDR')

    # make images flat
    for i in range(0, size):
        for j in range(0, size):
            images.append(arrayImages[i, j])

        # find the vertical and horizontal shifts of each image from the center image
    for i in range(0, size):
        for j in range(0, size):
            shift[i, j] = alignMTB.calculateShift(cv.cvtColor(images[i * size + j], cv.COLOR_BGR2GRAY),
                                                  cv.cvtColor(images[int((size * size - 1) / 2)], cv.COLOR_BGR2GRAY))

        # find the median horizontal and vertical shifts and use this for all the images (spacing is even)
    for i in range(0, size):
        for j in range(0, size):
            horShift[i * size + j] = shift[i, j, 0]
            vertShift[i * size + j] = shift[i, j, 1]

    for i in range(0, size):
        vertList[i] = vertShift[i * 3]

    horList = horShift[0:size]

    medHor = np.median(horList)
    medVert = np.median(vertList)

    if medHor == medVert:
        print('Success: shift up matched shift across')

    # make list of new shifts
    for i in range(0, size):
        for j in range(0, size):
            newShift[i * size + j, 1] = medHor * -(j - int((size - 1) / 2))
            newShift[i * size + j, 0] = medVert * -(i - int((size - 1) / 2))

    print(shift)
    print(newShift)

    # shift the image by the new shift values
    for i in range(0, size * size):
        imagesOutput.append(shift_image(images[i], newShift[i]))

    return imagesOutput

    ''' Demonstration of stiching usage
    images = []
    filenames = ['HDRAltered/' + parallax.image_filename('HDR', 1, 1), 'HDRAltered/' + parallax.image_filename('HDR', 1, 2)]
    
    for i in range(len(filenames)):
        images.append(cv.imread(filenames[i]))
        cv.imshow(str(i), images[i])
    
    cv.waitKey(0)
    
    stitching = cv.Stitcher.create()
    (dummy, output) = stitching.stitch(images)
    
    if dummy != cv.STITCHER_OK:
        # .stitch() function returns a true value if stitching success
        print("did not work")
    else:
        print('worked')
    
    # final output
    cv.imshow('final result', output)
    
    cv.imwrite('StitchingExample.png', output)
    
    cv.waitKey(0)
    '''

# translating the image by a shift matrix using the transformation matrix
def shift_image(inputImage, shift):
    image = inputImage
    horShift = int(shift[0])
    vertShift = int(shift[1])
    M = np.float32([[1, 0, horShift], [0, 1, vertShift]])
    (rows, cols) = image.shape[:2]

    outputImage = cv.warpAffine(image, M, (rows, cols))
    return outputImage


# TODO allow users to adjust the estimated exposure (absorption rate) for each absorption lens to get a better image
# i.e. a slider for max exposure and min exposure and assume equally distributed within take as inputs here
# HDR combination techniques applied to the final image
def HDR_combine(inputImages, maxAbs=100, minAbs=5):

    size = parallax.mml_size('HDR')
    exposure = np.zeros((size*size), dtype=np.float32)

    for i in range((size*size-1), -1, -1):  # highest absorption= lowest brightness= lowest exposure
        absorption = i * ((maxAbs-minAbs)/(size*size))+minAbs  # as absorption is linearly distributed
        exposure[i] = 1/absorption

    # Estimate the camera response function based on estimated exposure time
    calibrate = cv.createCalibrateDebevec()  # TODO try other methods i.e Robertson and Mertens Fusion
    # https://docs.opencv.org/4.x/d2/df0/tutorial_py_hdr.html
    response = calibrate.process(inputImages, exposure)

    # Merge images in to HDR image
    mergeDebevec = cv.createMergeDebevec()
    hdr = mergeDebevec.process(inputImages, exposure, response)

    # Tonemap the HDR- using Reinhard's method to obtain 24-bit color image
    tonemapReinhard = cv.createTonemapReinhard(1.5, 0, 0, 0)
    ldrReinhard = tonemapReinhard.process(hdr)

    # # Attempt at exposure fusion method
    # mergeExpoFus = cv.createMergeMertens()
    # expoFus = mergeExpoFus.process(inputImages)
    # cv.imshow('Exposure Fusion', expoFus)
    # res_mertens_8bit = np.clip(expoFus * 255, 0, 255).astype('uint8')
    # cv.imshow('Exposure Fusion', expoFus)


    # save the HDR image (first convert to 8 bit)
    hdr = np.clip(ldrReinhard*255, 0, 255).astype('uint8')  # change type and clip overflow
    cv.imwrite('HDRImage.png', hdr)
    # Rearrange colors- put into format readable by tkinter
    blue, green, red = cv.split(hdr)
    hdr = cv.merge((red, green, blue))
    hdr = Image.fromarray(hdr)
    hdrtk = ImageTk.PhotoImage(image=hdr)
    print('Image Saved')
    return hdrtk

