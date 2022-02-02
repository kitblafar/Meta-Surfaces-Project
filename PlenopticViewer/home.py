# Main page linking all components
import tkinter as tk
from tkinter import ttk
import parallax
import HDR
import depth
import numpy as np
import cv2 as cv
from PIL import Image, ImageTk


# Initial processing steps
def initial_tasks():
    parallax.im_resize('par')
    parallax.im_resize('HDR')
    parallax.im_resize('cal')
    # calibrate the camera and remove distortion
    depth.camera_calibrate()
    root.destroy()


# loading window
root = tk.Tk()
root.title('MML Viewer')
root.iconphoto(False, tk.PhotoImage(file='./Icon.png'))
label = tk.Label(root, text='loading...')
label.grid(row=0)

imageShow = tk.PhotoImage(file='./Icon.png')
imageFrame = tk.Label(root, image=imageShow)
imageFrame.grid(row=1, sticky='nsew')

root.after(200, initial_tasks)
root.mainloop()


class ToolBar(tk.Frame):
    def __init__(self, container):
        super().__init__(container)

        container.rowconfigure(0, weight=1)
        container.rowconfigure(1, weight=5)
        container.columnconfigure(0, weight=1)

        # set title bar parameters
        self.topFrame = tk.Frame(container)
        self.topFrame.grid(row=0, column=0, sticky=tk.NSEW)

        # Display toolbar in topFrame
        self.topFrame.columnconfigure(0, weight=1)
        self.topFrame.columnconfigure(1, weight=1)
        self.topFrame.columnconfigure(2, weight=1)
        self.topFrame.columnconfigure(3, weight=1)
        self.topFrame.columnconfigure(4, weight=1)
        self.topFrame.rowconfigure(0, weight=1)

        tk.Label(self.topFrame, anchor="center", text="Tool Bar").grid(row=0, column=0, sticky='new')
        ttk.Button(self.topFrame, text="Reconstructed", command=lambda: self.change_frame(0), ).grid(row=0, column=1,
                                                                                                     sticky='new')
        ttk.Button(self.topFrame, text="Parallax", command=lambda: self.change_frame(1), ).grid(row=0, column=2,
                                                                                                sticky='new')
        ttk.Button(self.topFrame, text="HDR", command=lambda: self.change_frame(2)).grid(row=0, column=3,
                                                                                         sticky='new')
        ttk.Button(self.topFrame, text="Depth", command=lambda: self.change_frame(3)).grid(row=0, column=4,
                                                                                           sticky='new')

        # Display the changeable content in a bottomFrame slit into left and right sides
        self.bottomFrame = tk.Frame(container)
        self.bottomFrame.grid(row=1, column=0, sticky=tk.NSEW)
        self.bottomFrame.rowconfigure(0, weight=1)
        self.bottomFrame.columnconfigure(0, weight=1)
        self.bottomFrame.columnconfigure(1, weight=1)
        self.frame = Reconstructed(self.bottomFrame)

    def change_frame(self, page):
        if page == 0:
            self.frame = Reconstructed(self.bottomFrame)
        elif page == 1:
            self.frame = parallax.ParallaxPage(self.bottomFrame)
        elif page == 2:
            self.frame = HDR.HDRPage(self.bottomFrame)
        elif page == 3:
            self.frame = depth.DepthPage(self.bottomFrame)
        else:
            print('Page reference not found.')

# show the reconstructed image frame by default
class Reconstructed(tk.Frame):
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

        # Display reconstucted image in right_frame
        self.HDRImage = tk.Frame(right_frame, bg='#f0f0f0')
        self.HDRImage.rowconfigure(0, weight=5)
        self.HDRImage.columnconfigure(0, weight=5)
        self.HDRImage.grid(row=0, column=0, sticky='nsew')

        # Find the main image fileName
        self.filename = parallax.image_filename('HDR', 1, 1)
        self.image = reconstruct_image()

        # main image
        self.mainIm = tk.Label(self.HDRImage, image=self.image)
        self.mainIm.grid(row=0, column=0)

        # Create parallax parameters frame in the left frame
        parPar = tk.Frame(left_frame)
        parPar.rowconfigure(0, weight=1)
        parPar.columnconfigure(0, weight=1)
        parPar.columnconfigure(1, weight=1)
        parPar.grid(row=0, column=0)

        # Example labels that could be displayed under the "Tool" menu
        tk.Label(parPar, text="Number of MMLs (assumed square array):").grid(row=0, column=0, padx=5, pady=5,
                                                                             sticky='n')
        tk.Entry(parPar).grid(row=0, column=1, padx=5, pady=5, sticky='n')
        container.tkraise()


def reconstruct_image():
    [a, shiftHor, shiftVert] = HDR.align_images('par')
    shiftHor = abs(int(shiftHor))
    shiftVert = abs(int(shiftVert))
    imageSet = depth.read_images('par')
    print(shiftVert)
    print(shiftHor)

    size = parallax.mml_size('par')
    imageSize = imageSet[1, 1].shape[0]
    # create an empty array to fill with the reconstructed image
    imageReconstruct = np.zeros([imageSize+shiftVert*2, imageSize+shiftHor*2, 3], dtype=np.uint8)
    print(imageReconstruct.shape)

    # populate array
    for i in range(0, size):
        for j in range(0, size):
            lowerHor = i*shiftHor
            upperHor = i*shiftHor+imageSize
            lowerVert = j*shiftVert
            upperVert = j*shiftVert+imageSize
            # print('horizontal- Upper:', upperHor, 'Lower:', lowerHor)
            # print('vertical- Upper:', upperVert, 'Lower:', lowerVert)

            imageReconstruct[lowerVert:upperVert, lowerHor: upperHor] = imageSet[i, j]
            # cv.imshow('reconstructed', imageReconstruct)
            # cv.waitKey(0)

    # put the middle image in for best result
    middle = int((size-1)/2)
    imageReconstruct[shiftVert:shiftVert+imageSize, shiftHor: shiftHor+imageSize] = imageSet[middle, middle]

    # change image into a form that works for tkinter
    imageReconstruct = cv.cvtColor(imageReconstruct, cv.COLOR_BGR2RGB)
    imageReconstruct = cv.resize(imageReconstruct, (500, 500))
    imageReconstruct = Image.fromarray(imageReconstruct)
    imageReconstruct = ImageTk.PhotoImage(image=imageReconstruct)

    return imageReconstruct

    # # put the middle image in for best result
    # middle = int((size-1)/2)
    # imageReconstruct[shiftVert:shiftVert+imageSize, shiftHor: shiftHor+imageSize] = imageSet[middle, middle]

    # change image into a form that works for tkinter
    imageReconstruct = cv.cvtColor(imageReconstruct, cv.COLOR_BGR2RGB)
    imageReconstruct = cv.resize(imageReconstruct, (500, 500))
    imageReconstruct = Image.fromarray(imageReconstruct)
    imageReconstruct = ImageTk.PhotoImage(image=imageReconstruct)

    return imageReconstruct



class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title('MML Viewer')
        self.iconphoto(False, tk.PhotoImage(file='./Icon.png'))
        self.geometry('900x600')
        self.resizable(True, True)


if __name__ == "__main__":
    app = App()
    ToolBar(app)
    app.mainloop()
