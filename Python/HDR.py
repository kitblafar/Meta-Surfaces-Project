# Functions used to align images and perform HDR imaging
import tkinter as tk
from tkinter import ttk
import parallax
import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt


class HDRPage(tk.Frame):
    def __init__(self, container):
        super().__init__(container)
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
        self.slide_image = tk.Frame(right_frame, bg='#f0f0f0')
        self.slide_image.rowconfigure(0, weight=5)
        self.slide_image.columnconfigure(0, weight=5)
        self.slide_image.grid(row=0, column=0, sticky='nsew')

        # Find the main image fileName
        self.filename = parallax.image_filename('HDR', 1, 1)
        self.image = tk.PhotoImage(file='HDRAltered/' + self.filename)

        # main image
        self.mainIm = tk.Label(self.slide_image, image=self.image)
        self.mainIm.grid(row=0, column=0)

        # Create parallax parameters frame in the left frame
        par_par = tk.Frame(left_frame)
        par_par.rowconfigure(0, weight=1)
        par_par.rowconfigure(1, weight=1)
        par_par.columnconfigure(0, weight=1)
        par_par.columnconfigure(1, weight=1)
        par_par.grid(row=0, column=0)

        # Example labels that serve as placeholders for other widgets
        ttk.Button(par_par, text="Inputs").grid(row=0, column=0, padx=5, pady=3, ipadx=10, sticky='s')
        ttk.Button(par_par, text="Viewing").grid(row=0, column=1, padx=5, pady=3, ipadx=10, sticky='s')

        # Example labels that could be displayed under the "Tool" menu
        tk.Label(par_par, text="File Location of Images").grid(row=1, column=0, padx=5, pady=5, sticky='n')
        tk.Entry(par_par).grid(row=1, column=1, padx=5, pady=5, sticky='n')
        container.tkraise()


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
def HDR_combine(inputImages):
    maxAbs = 2.5
    minAbs = 0.25
    size = parallax.mml_size('HDR')
    exposure = np.zeros((size*size), dtype=np.float32)
    print(exposure)

    for i in range((size*size-1), -1, -1): # highest absorption= lowest brightness= lowest exposure
        absorption = i * ((maxAbs-minAbs)/(size*size))+minAbs  # as absorption is linearly distributed
        print(absorption)
        exposure[i] = 1/absorption


    # Estimate the camera response function based on estimated exposure time
    calibrate = cv.createCalibrateDebevec()  # TODO try other methods
    response = calibrate.process(inputImages, exposure)

    # Merge images in to HDR image
    mergeDebevec = cv.createMergeDebevec()
    hdr = mergeDebevec.process(inputImages, exposure, response)

    # show the HDR image
    cv.imshow('HDR', hdr)
    cv.waitKey(0)


# test HDR
images = align_images()
HDR_combine(images)
