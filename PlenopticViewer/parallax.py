# Function to Return the Correct Image Based on Slider Position #
import os
import math

import numpy as np
import cv2 as cv
import tkinter as tk
from tkinter import ttk

import depth


class ParallaxPage(tk.Frame):
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
        rightFrame.grid(row=0, column=1)

        # Display light field draggable image in rightFrame
        self.slideImage = tk.Frame(rightFrame, bg='#f0f0f0')
        self.slideImage.rowconfigure(0, weight=5)
        self.slideImage.rowconfigure(1, weight=1)
        self.slideImage.columnconfigure(0, weight=5)
        self.slideImage.columnconfigure(1, weight=1)
        self.slideImage.grid(row=1, column=0, sticky='nsew')

        # top slider
        mmlSize = mml_size('par')
        self.S1 = tk.Scale(self.slideImage, from_=1, to=mmlSize, orient=tk.HORIZONTAL, command=self.image_update)
        self.S1.grid(row=0, column=0, sticky=tk.EW)
        # right slider
        self.S2 = tk.Scale(self.slideImage, from_=1, to=mmlSize, orient=tk.VERTICAL, command=self.image_update)
        self.S2.grid(row=1, column=1, sticky=tk.NS)

        # Find the main image fileName
        self.fileName = image_filename('par', 1, 1)
        self.image = tk.PhotoImage(file='ParallaxAltered/' + self.fileName)

        # main image
        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=1, column=0, sticky=tk.NSEW)

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

    def image_update(self, number):
        sl1 = int(self.S1.get())
        sl2 = int(self.S2.get())
        self.fileName = image_filename('par', sl1, sl2)
        self.fileName = 'ParallaxAltered/' + self.fileName
        self.image = tk.PhotoImage(file=self.fileName)
        self.mainIm = tk.Label(self.slideImage, image=self.image)
        self.mainIm.grid(row=1, column=0)


# TODO Read the files from the file location given by the user (replace ../TreeScene)
# TODO Use the functions to return variables that define the GUI (mml_size=slider _to, im_size= slider length)

# find MML dimension N (NxN)
def mml_size(name):
    if name == 'par' or name == 'depth':
        noMMLs = 9
        # TODO make this a user input
    elif name == 'HDR':
        noMMLs = len(os.listdir('Absorption'))  # count the number of images available
    else:
        print('Please give a name of `par`, `HDR` or `depth`')
    noMMLs = int(math.sqrt(noMMLs))
    return noMMLs


def images_seperate(image):
    mmlSize = mml_size('par')
    fullImage = image
    # rotate the images 180 degrees
    fullImage = cv.flip(fullImage, 0)
    fullSize = fullImage.shape[0]
    imageSize = int(fullSize / mmlSize)
    images = np.zeros((mmlSize, mmlSize, imageSize, imageSize, 3), dtype=np.uint8)

    # separate the full image from the plenoptic camera
    for i in range(0, mmlSize):
        for j in range(0, mmlSize):
            images[i, j] = fullImage[int(imageSize * i):int(imageSize * (i + 1)),
                           int(imageSize * j):int(imageSize * (j + 1))]

    return images


# read, separate (if necessary) and resize a given image set
def im_resize(name):
    # setting up parameters
    mmlSize = 0
    imageSize = 0
    fileName = 'none'
    images = np.zeros((mmlSize, mmlSize, 1000, 1000, 3), dtype=np.uint8)
    newLocation = 'ParallaxAltered/'

    if name == 'par' or name == 'depth':
        images = depth.read_images('par', 'init')
        mmlSize = mml_size('par')
        newLocation = 'ParallaxAltered/'
    elif name == 'cal':
        images = depth.read_images('cal', 'init')
        mmlSize = mml_size('par')
        newLocation = 'CalibrationAltered/'
    elif name == 'HDR':
        mmlSize = mml_size('HDR')
        images = depth.read_images('HDR', 'init')
        newLocation = 'HDRAltered/'
    else:
        print('Please give a name of `par`, `cal`, `HDR` or `depth`')

    imageSize = images[1, 1].shape[0]
    print(imageSize, ' ', name)

    # set up crop conditions
    squareSize = math.sqrt(imageSize * imageSize / 2) - 3
    diff = int((imageSize - squareSize) / 2)
    # do a tighter crop than the absolute minimum for HDR
    if name == 'HDR':
        diff = int(diff*1.5)

    for i in range(1, mmlSize + 1):
        for j in range(1, mmlSize + 1):
            # crop to square the size of lens
            # print(i, ' ', j)
            image = images[i-1, j-1]
            image = image[diff:(imageSize - diff), diff:(imageSize - diff)]
            # resize the altered image to 500 pixels squared
            image = cv.resize(image, (500, 500))
            # save the altered image set
            if name == 'par' or name == 'depth':
                fileName = image_filename('par', i, j)
            elif name == 'cal':
                fileName = image_filename('cal', i, j)
            elif name == 'HDR':
                fileName = image_filename('HDR', i, j)
            cv.imwrite(newLocation + fileName, image)


# return the correct image from the file corresponding to the slider value in the form fa_11.png
# NOTE: outdated for new camera type render
def image_filename(name, sl1, sl2):
    col = str(sl1)
    row = str(sl2)
    if name == 'par' or name == 'depth':
        groupName = 'par'
    elif name == 'cal':
        groupName = 'cal'
    elif name == 'HDR':
        groupName = 'HDR'
    else:
        print('Please give a name of `par`, `HDR` or `depth`')

    fileName = groupName + '_' + row + col + '.png'
    return fileName
