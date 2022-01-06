# Main page linking all components
import tkinter as tk
from tkinter import ttk
import parallax
import HDR
import depth
from PIL import Image
from tkinter.messagebox import showerror


# Initial processing steps
def initial_tasks():
    # parallax.im_resize('par')
    # parallax.im_resize('HDR')
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
        self.frame = 0

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
        self.topFrame.rowconfigure(0, weight=1)

        tk.Label(self.topFrame, anchor="center", text="Tool Bar").grid(row=0, column=0, sticky='new')
        ttk.Button(self.topFrame, text="Parallax", command=lambda: self.change_frame(0), ).grid(row=0, column=1,
                                                                                                sticky='new')
        ttk.Button(self.topFrame, text="HDR", command=lambda: self.change_frame(1)).grid(row=0, column=2,
                                                                                         sticky='new')
        ttk.Button(self.topFrame, text="Depth", command=lambda: self.change_frame(2)).grid(row=0, column=3,
                                                                                           sticky='new')

        # Display the changeable content in a bottomFrame slit into left and right sides
        self.bottomFrame = tk.Frame(container)
        self.bottomFrame.grid(row=1, column=0, sticky=tk.NSEW)
        self.bottomFrame.rowconfigure(0, weight=1)
        self.bottomFrame.columnconfigure(0, weight=1)
        self.bottomFrame.columnconfigure(1, weight=1)
        self.welcomeFrame = tk.Label(self.bottomFrame, text='Choose Viewing Option')
        self.welcomeFrame.pack(expand=True)

    def change_frame(self, page):
        self.welcomeFrame.destroy()
        if page == 0:
            self.frame = parallax.ParallaxPage(self.bottomFrame)
        elif page == 1:
            self.frame = HDR.HDRPage(self.bottomFrame)
        elif page == 2:
            self.frame = depth.DepthPage(self.bottomFrame)
        else:
            print('Page reference not found.')


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
