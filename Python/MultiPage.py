import tkinter as tk
from tkinter import ttk
import parallax
from tkinter.messagebox import showerror


class ToolBarFrame(tk.Frame):
    def __init__(self, container):
        super().__init__(container)
        self.frame = 0
        container.iconphoto(False, tk.PhotoImage(file='./Icon.png'))
        self.top_frame = tk.Frame(container, width=900, height=100)
        self.top_frame.grid(row=0, column=0, sticky=tk.NSEW)

        # Display toolbar in top_frame
        self.top_frame.columnconfigure(0, weight=1, minsize=900/4)
        self.top_frame.columnconfigure(1, weight=1, minsize=900/4)
        self.top_frame.columnconfigure(2, weight=1, minsize=900/4)
        self.top_frame.columnconfigure(3, weight=1, minsize=900/4)

        tk.Label(self.top_frame, height=5, text="Tool Bar").grid(row=0, column=0, sticky=tk.NSEW)
        ttk.Button(self.top_frame, text="Parallax", command=lambda: self.change_frame(0), ).grid(row=0, column=1, sticky=tk.NSEW)
        ttk.Button(self.top_frame,  text="HDR",  command=lambda: self.change_frame(1)).grid(row=0, column=2, sticky=tk.NSEW)
        ttk.Button(self.top_frame, text="Depth", command=lambda: self.change_frame(2)).grid(row=0, column=3, sticky=tk.NSEW)

        # Display the changeable content in a bottom_frame
        self.bottom_frame = tk.Frame(container, width=900, height=500)
        self.bottom_frame.grid(row=1, column=0, sticky=tk.NSEW)
        self.bottom_frame.rowconfigure(0, weight=1, minsize=500)
        self.left_frame = tk.Frame(self.bottom_frame)
        self.left_frame.grid(row=0, column=0, sticky=tk.NSEW)
        self.left_frame.columnconfigure(0, weight=1, minsize=300)
        self.right_frame = tk.Frame(self.bottom_frame)
        self.right_frame.grid(row=0, column=1, sticky=tk.NSEW)
        self.right_frame.columnconfigure(0, weight=1, minsize=600)

    def change_frame(self, page):
        if page == 0:
            self.frame = ParallaxPage(self.left_frame, self.right_frame)
        elif page == 1:
            self.frame = HDRPage(self.bottom_frame)
        elif page == 2:
            self.frame = DepthPage(self.bottom_frame)
        else:
            print('oopsie')


class ParallaxPage(tk.Frame):
    def __init__(self, left, right):
        super().__init__(left, right)
        # Find the image filename
        self.filename = parallax.image_filename(1, 1)
        self.image = tk.PhotoImage(file='Altered/' + self.filename)


        # Display light field draggable image in right_frame
        self.slide_image = tk.Frame(right)
        self.slide_image.grid(row=1, column=0)
        # top slider
        self.S1 = tk.Scale(self.slide_image, from_=1, to=9, orient=tk.HORIZONTAL, command=self.image_update)
        self.S1.grid(row=0, column=0, sticky=tk.NSEW)
        # right slider
        self.S2 = tk.Scale(self.slide_image, from_=1, to=9, orient=tk.VERTICAL, command=self.image_update)
        self.S2.grid(row=1, column=1, sticky=tk.NSEW)

        # main image
        self.mainIm = tk.Label(self.slide_image, image=self.image)
        self.mainIm.grid(row=1, column=0, sticky=tk.NSEW)

        # Create parallax parameters frame
        par_par = tk.Frame(left)
        par_par.grid(row=0, column=0)

        # Example labels that serve as placeholders for other widgets
        ttk.Button(par_par, text="Inputs").grid(row=0, column=0, padx=5, pady=3, ipadx=10)
        ttk.Button(par_par, text="Viewing").grid(row=0, column=1, padx=5, pady=3, ipadx=10)

        # Example labels that could be displayed under the "Tool" menu
        tk.Label(par_par, text="File Location of Images").grid(row=1, column=0, padx=5, pady=5)
        tk.Entry(par_par).grid(row=1, column=1, padx=5, pady=5)

    def image_update(self, number):
        sl1 = int(self.S1.get())
        sl2 = int(self.S2.get())
        self.filename = parallax.image_filename(sl1, sl2)
        self.filename = 'Altered/' + self.filename
        self.image = tk.PhotoImage(file=self.filename)
        self.mainIm = tk.Label(self.slide_image, image=self.image)
        self.mainIm.grid(row=1, column=0)


class HDRPage(tk.Frame):
    pass


class DepthPage(tk.Frame):
    pass


class App(tk.Tk):
    def __init__(self):
        super().__init__()

        self.title('MML Viewer')
        self.geometry('900x600')
        self.minsize(900, 600)
        self.resizable(True, True)


if __name__ == "__main__":
    app = App()
    ToolBarFrame(app)
    app.mainloop()
