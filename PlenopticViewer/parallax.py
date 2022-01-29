# Function to Return the Correct Image Based on Slider Position #
import os
import math
from PIL import Image
import tkinter as tk
from tkinter import ttk


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
        self.S1 = tk.Scale(self.slideImage, from_=1, to=9, orient=tk.HORIZONTAL, command=self.image_update)
        self.S1.grid(row=0, column=0, sticky=tk.EW)
        # right slider
        self.S2 = tk.Scale(self.slideImage, from_=1, to=9, orient=tk.VERTICAL, command=self.image_update)
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
        noMMLs = os.listdir('TreeScene')  # count the number of images available
    elif name == 'HDR':
        noMMLs = os.listdir('Absorption')  # count the number of images available
    else:
        print('Please give a name of `par`, `HDR` or `depth`')
    noMMLs = int(math.sqrt(len(noMMLs)))
    return noMMLs

# resize a given image set
def im_resize(name):
    # setting up parameters for crop
    if name == 'par':
        originalLocation = 'TreeScene/'
        newLocation = 'ParallaxAltered/'
        mmlSize = mml_size('par')
    elif name == 'depth':
        originalLocation = 'Depth/'
        newLocation = 'DepthAltered/'
        mmlSize = mml_size('depth')
    elif name == 'HDR':
        originalLocation = 'Absorption/'
        newLocation = 'HDRAltered/'
        mmlSize = mml_size('HDR')
    else:
        print('Please give a name of `par`, `HDR` or `depth`')

    imageSize = Image.open(originalLocation + image_filename(name, 1, 1)).size[0]
    print(imageSize, ' ', name)
    squareSize = math.sqrt(imageSize * imageSize / 2) - 3
    diff = int((imageSize - squareSize) / 2)

    # TODO Render images for HDR with less lens in
    if name == 'HDR':  # HDR requires a tighter crop so no lens is shown
        diff = diff*1.5

    box = (diff, diff, (imageSize - diff), (imageSize - diff))
    for i in range(1, mmlSize + 1):
        for j in range(1, mmlSize + 1):
            fileName = image_filename(name, i, j)
            im = Image.open(originalLocation + fileName)
            # crop to square the size of lens
            image = im.crop(box)
            # rotate the images 180 degrees
            transpose = image.transpose(Image.ROTATE_180)
            # resize the altered image to 500 pixels squared
            final = transpose.resize((500, 500))
            # save the altered image set
            final.save(newLocation + fileName)


# return the correct image from the file corresponding to the slider value in the form fa_11.png
def image_filename(name, sl1, sl2):
    col = str(sl1)
    row = str(sl2)
    if name == 'par':
        groupName = 'fa'
    elif name == 'depth':
        groupName = 'de'
    elif name == 'HDR':
        groupName = 'abs'
    else:
        print('Please give a name of `par`, `HDR` or `depth`')

    fileName = groupName + '_' + row + col + '.png'
    return fileName
