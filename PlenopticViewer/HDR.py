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
        [self.imageSet, x, y] = align_images()

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

        label1 = tk.Label(parPar, text="Maximum Absorption (between 5 and 50)")
        label1.grid(row=0, column=0, padx=5, pady=5, sticky='n')
        self.sl1 = ttk.Scale(parPar, from_=5, to=50, orient=tk.HORIZONTAL)
        self.sl1.bind('<ButtonRelease>', self.update_absorb)
        self.sl1.grid(row=1, column=0, sticky='NSEW')
        label2 = tk.Label(parPar, text="Minimum Absorption (between 0 and 10)")
        label2.grid(row=2, column=0)
        self.sl2 = ttk.Scale(parPar, from_=0, to=10, orient=tk.HORIZONTAL)
        self.sl2.bind('<ButtonRelease>', self.update_absorb)
        self.sl2.grid(row=3, column=0, sticky='NSEW')

    def update_absorb(self, number):
        maxAbs = self.sl1.get()
        print('Max Absorption=' + str(maxAbs))
        minAbs = self.sl2.get()
        print('Min Absorption=' + str(minAbs))

        if minAbs == 0:
            minAbs = 0.001

        # update image
        self.image = HDR_combine(self.imageSet, maxAbs, minAbs)
        self.mainIm = tk.Label(self.HDRImage, image=self.image)
        self.mainIm.grid(row=0, column=0)


"""find the overlap between two neighbouring images (with middle absorption= best chance of features) and remove 
overlap from all images (spiral) lens spacing and therefore overlap are constant between images """
# TODO stitch two images, stitched image length- original image length= cut-off
"""as the parallax is small (in reality), aligning using the expose align built into opencv should work"""


# align the images to a centre point
def align_images(name='HDR'):
    imagesOutput = []
    images = []

    if name == 'HDR':
        alignMTB = cv.createAlignMTB()  # use open cv align med function to get estimate of shifts
        # read images into an array
        arrayImages = depth.read_images('HDR')
        size = parallax.mml_size('HDR')
    else:
        arrayImages = depth.read_images('par')
        size = parallax.mml_size('par')
        # window to reduce edge effects
        imageSize = arrayImages[1, 1].shape[0]
        hannW = cv.createHanningWindow([imageSize, imageSize], cv.CV_32F)

    newShift = np.zeros([size*size, 2])
    shift = np.zeros([size,size, 2])
    vertList = np.zeros([(size-1)*(size-1), 1])
    horList = np.zeros([(size - 1) * (size - 1), 1])

    # make images flat
    for i in range(0, size):
        for j in range(0, size):
            images.append(arrayImages[i, j])

    # find the vertical and horizontal shifts of each image from the center image
    for i in range(0, size-1):
        for j in range(0, size-1):
            if name == 'HDR':
                prevIm = cv.cvtColor(arrayImages[i, j], cv.COLOR_BGR2GRAY)
                curImHor = cv.cvtColor(arrayImages[i, j + 1], cv.COLOR_BGR2GRAY)
                curImVert = cv.cvtColor(arrayImages[i + 1, j], cv.COLOR_BGR2GRAY)
                vertList[i*(size-1)+j] = alignMTB.calculateShift(curImVert, prevIm)[0]
                horList[i * (size - 1) + j] = alignMTB.calculateShift(curImHor, prevIm)[1]

            else:
                prevIm = cv.cvtColor(arrayImages[i, j], cv.COLOR_BGR2GRAY)
                prevIm = np.float32(prevIm)
                curImVert = cv.cvtColor(arrayImages[i, j+1], cv.COLOR_BGR2GRAY)
                curImVert = np.float32(curImVert)
                curImHor = cv.cvtColor(arrayImages[i+1, j], cv.COLOR_BGR2GRAY)
                curImHor = np.float32(curImHor)
                vertList[i*(size-1)+j] = cv.phaseCorrelate(prevIm, curImVert, hannW)[0][1]
                horList[i*(size-1)+j] = cv.phaseCorrelate(prevIm, curImHor, hannW)[0][0]

    # print(horList)
    # print(vertList)
    medHor = np.median(horList)
    medVert = np.median(vertList)

    # for HDR take the median value of the shifts (there is variation here)
    for i in range(0, size):
        for j in range(0, size):
            newShift[i * size + j, 1] = medHor * -(j - int((size - 1) / 2))
            newShift[i * size + j, 0] = medVert * -(i - int((size - 1) / 2))

    # print(vertShiftLine)

    # shift the image by the new shift values if doing HDR
    if name == 'HDR':
        for i in range(0, size * size):
            shiftImages = shift_image(images[i], newShift[i])
            imagesOutput.append(shiftImages)

    # # crop the images for reconstruction (not used)
    # else:
    #     vertShift = int(newShift[i][0])
    #     horShift = int(newShift[i][1])
    #     # print(str(i), ' horizontal shift: ', horShift, ' vertical shift: ', vertShift)
    #     imageSize = shiftImages.shape[0]
    #     if horShift < 0:
    #         if vertShift < 0:
    #             cropImage = shiftImages[0:(imageSize - abs(horShift)), 0:(imageSize - abs(horShift))]
    #         else:
    #             cropImage = shiftImages[0:(imageSize - abs(horShift)), abs(vertShift):imageSize]  # correct
    #     else:
    #         if vertShift < 0:
    #             cropImage = shiftImages[abs(horShift):imageSize, 0:(imageSize - abs(vertShift))]
    #         else:
    #             cropImage = shiftImages[abs(horShift):imageSize, abs(vertShift):imageSize]
    #
    #     imagesOutput.append(cropImage)

    #image output blank for image reconstructoin, shift values blank for HDR
    return imagesOutput, medHor, medVert


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
def HDR_combine(inputImages, maxAbs=5, minAbs=0.5):
    size = parallax.mml_size('HDR')
    exposure = np.zeros((size * size), dtype=np.float32)

    for i in range((size * size - 1), -1, -1):  # highest absorption= lowest brightness= lowest exposure
        absorption = i * ((maxAbs - minAbs) / (size * size)) + minAbs  # as absorption is linearly distributed
        exposure[i] = 1 / absorption

    # Merge images in to HDR image
    mergeDebvec = cv.createMergeDebevec()
    hdr = mergeDebvec.process(inputImages, times=exposure.copy())

    # Tonemap the HDR- using Reinhard's method to obtain 24-bit color image
    tonemapReinhard = cv.createTonemapReinhard(1, 0, 0, 0)
    ldrReinhard = tonemapReinhard.process(hdr)

    # # Attempt at exposure fusion method
    # mergeExpoFus = cv.createMergeMertens()
    # expoFus = mergeExpoFus.process(inputImages)
    # cv.imshow('Exposure Fusion', expoFus)
    # res_mertens_8bit = np.clip(expoFus * 255, 0, 255).astype('uint8')
    # cv.imshow('Exposure Fusion', expoFus)

    # save the HDR image (first convert to 8 bit)
    hdr = np.clip(ldrReinhard * 255, 0, 255).astype('uint8')  # change type and clip overflow
    cv.imwrite('HDRImage.png', hdr)
    # Rearrange colors- put into format readable by tkinter
    blue, green, red = cv.split(hdr)
    hdr = cv.merge((red, green, blue))
    hdr = Image.fromarray(hdr)
    hdrtk = ImageTk.PhotoImage(image=hdr)
    print('Image Saved')
    return hdrtk

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
