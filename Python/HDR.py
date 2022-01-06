# Functions used to align images and perform HDR imaging
import tkinter as tk
from tkinter import ttk
import parallax
import cv2 as cv
import numpy as np


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


""" find the overlap between two neighbouring images (with middle absorption= best chance of features) and remove overlap from all images (spiral)
lens spacing and therefore overlap are constant between images"""
# TODO stitch two images, stitched image length- original image length= cut-off
images = []
filenames = []
size = parallax.mml_size('HDR')
for i in range(1, size+1):
    for j in range(1, size+1):
        filenames.append('HDRAltered/' + parallax.image_filename('HDR', j, i))
        print(filenames)

for i in range(len(filenames)):
    images.append(cv.imread(filenames[i]))
    cv.imshow(str(i), images[i])

cv.waitKey(0)

stitchy = cv.Stitcher.create()
(dummy, output) = stitchy.stitch(images)

if dummy != cv.STITCHER_OK:
    # checking if the stitching procedure is sucessful
    # .stitch() function returns a true value if stitching is
    # done successfully
    print("stitching ain't successful")
else:
    print('Your Panorama is ready!!!')

# final output
cv.imshow('final result', output)

cv.waitKey(0)



