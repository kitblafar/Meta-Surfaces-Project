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
root.title('MML Array Viewer')
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
    imageSet = depth.read_images('par')
    shiftHor = shiftHor.astype(int)
    shiftVert = shiftVert.astype(int)

    # make each element the sum of the last
    shiftHor = np.cumsum(shiftHor)
    shiftVert = np.cumsum(shiftVert)

    # add zero at beginning as initially no shift
    shiftHor = np.insert(shiftHor, 0, 0)
    shiftVert = np.insert(shiftVert, 0, 0)

    # print(shiftVert)
    # print(shiftHor)

    size = parallax.mml_size('par')

    imageSize = imageSet[1, 1].shape[0]
    # create an empty array to fill with the reconstructed image
    # find the last element of vert and hor shift this is max shift in each direction
    lenHor = len(shiftHor)
    fullHor = shiftHor[lenHor - 1]
    lenVert = len(shiftVert)
    fullVert = shiftVert[lenVert - 1]
    imageReconstruct = np.zeros([imageSize - fullVert, imageSize - fullHor, 3], dtype=np.uint8)
    # print(imageReconstruct.shape)

    # populate array
    for i in range(0, size):  # sets horizontal
        for j in range(0, size):  # sets vertical
            lowerHor = -shiftHor[i]
            upperHor = -shiftHor[i] + imageSize
            lowerVert = -shiftVert[j]
            upperVert = -shiftVert[j] + imageSize
            # print('horizontal- Upper:', upperHor, 'Lower:', lowerHor)
            # print('vertical- Upper:', upperVert, 'Lower:', lowerVert, '\n')

            imageReconstruct[lowerVert:upperVert, lowerHor: upperHor] = imageSet[i, j]
            # fileName = 'Reconstruct' + str(i) + str(j)
            # cv.imwrite('Recon/' + fileName + '.png', imageReconstruct)
            # cv.imshow('reconstructed', imageReconstruct)
            # cv.waitKey(0)

    # change image into a form that works for tkinter
    imageReconstruct = cv.cvtColor(imageReconstruct, cv.COLOR_BGR2RGB)
    imageReconstruct = cv.resize(imageReconstruct, (500, 500))
    imageReconstruct = Image.fromarray(imageReconstruct)
    imageReconstruct = ImageTk.PhotoImage(image=imageReconstruct)

    return imageReconstruct

    # change image into a form that works for tkinter
    imageReconstruct = cv.cvtColor(imageReconstruct, cv.COLOR_BGR2RGB)
    imageReconstruct = cv.resize(imageReconstruct, (500, 500))
    imageReconstruct = Image.fromarray(imageReconstruct)
    imageReconstruct = ImageTk.PhotoImage(image=imageReconstruct)

    return imageReconstruct


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title('MML Array Viewer')
        self.iconphoto(False, tk.PhotoImage(file='./Icon.png'))
        self.geometry('1000x600')
        self.resizable(True, True)


if __name__ == "__main__":
    app = App()
    ToolBar(app)
    app.mainloop()
