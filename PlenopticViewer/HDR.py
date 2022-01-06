# Functions used to align images and perform HDR imaging
import tkinter as tk
from tkinter import ttk
import parallax
import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt
from PIL import Image, ImageTk


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
        label2 = tk.Label(parPar, text="Minimum Absorption (between 0 and 5)")
        label2.grid(row=2, column=0)
        self.sl2 = ttk.Scale(parPar, from_=0, to=5, orient=tk.HORIZONTAL)
        self.sl2.bind('<ButtonRelease>', self.update_absorb)
        self.sl2.grid(row=3, column=0, sticky='NSEW')

    def update_absorb(self, number):
        minAbs = float(self.sl1.get())
        print(minAbs)
        maxAbs = float(self.sl2.get())
        #update image
        self.image = HDR_combine(self.imageSet, maxAbs, minAbs)
        self.mainIm = tk.Label(self.HDRImage, image=self.image)
        self.mainIm.grid(row=0, column=0)



"""find the overlap between two neighbouring images (with middle absorption= best chance of features) and remove 
overlap from all images (spiral) lens spacing and therefore overlap are constant between images """
# TODO stitch two images, stitched image length- original image length= cut-off
"""as the parallax is small (in reality), aligning using the expose align built into opencv should work"""


def align_images():
    images = []
    size = parallax.mml_size('HDR')

    # read images into an array
    for i in range(1, size+1):
        for j in range(1, size+1):
            filename = 'HDRAltered/'+parallax.image_filename('HDR', j, i)
            im = cv.imread(filename)
            images.append(im)

    # align the images
    alignMTB = cv.createAlignMTB()
    alignMTB.process(images, images)

    # # show the aligned images
    # for i in range(1, (size+1)*(size+1)):
    #     cv.imshow(str(i), images[i])
    #
    # cv.waitKey(0)
    return images
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


# TODO allow users to adjust the estimated exposure (absorption rate) for each absorption lens to get a better image
# i.e. a slider for max exposure and min exposure and assume equally distributed within take as inputs here
def HDR_combine(inputImages, maxAbs=15.0, minAbs=0.5):
    size = parallax.mml_size('HDR')
    exposure = np.zeros((size*size), dtype=np.float32)

    for i in range((size*size-1), -1, -1): # highest absorption= lowest brightness= lowest exposure
        absorption = i * ((maxAbs-minAbs)/(size*size))+minAbs  # as absorption is linearly distributed
        print(absorption)
        exposure[i] = 1/absorption

    # Estimate the camera response function based on estimated exposure time
    calibrate = cv.createCalibrateDebevec()  # TODO try other methods i.e Robertson and Mertens Fusion
    # https://docs.opencv.org/4.x/d2/df0/tutorial_py_hdr.html
    response = calibrate.process(inputImages, exposure)

    # Merge images in to HDR image
    mergeDebevec = cv.createMergeDebevec()
    hdr = mergeDebevec.process(inputImages, exposure, response)

    # Tonemap the HDR- Done to map 32 bit number onto 1 to 0 range (although some time larger therefore clip used)
    tonemap1 = cv.createTonemap(gamma=2.2)
    res_debevec = tonemap1.process(hdr.copy())

    # # Attempt at exposure fusion method
    # mergeExpoFus = cv.createMergeMertens()
    # expoFus = mergeExpoFus.process(inputImages)
    # cv.imshow('Exposure Fusion', expoFus)
    # res_mertens_8bit = np.clip(expoFus * 255, 0, 255).astype('uint8')
    # cv.imshow('Exposure Fusion', expoFus)

    # save the HDR image (first convert to 8 bit)
    hdr = np.clip(res_debevec*255, 0, 255).astype('uint8') # change type and clip overflow
    cv.imwrite('HDRImage.png', hdr)
    # Rearrange colors- put into format readable by tkinter
    blue, green, red = cv.split(hdr)
    hdr = cv.merge((red, green, blue))
    hdr = Image.fromarray(hdr)
    hdrtk = ImageTk.PhotoImage(image=hdr)
    print('Image Saved')
    return hdrtk


