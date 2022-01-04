# GUI FOR LIGHT FIELD IMAGE VIEWING #

# import tkinter and all its functions
import tkinter as tk
import parallax

# resize all the images in the set
parallax.im_resize()

root = tk.Tk()  # create root window
root.title("Light Field Imaging GUI")  # title of the GUI window
root.iconphoto(False, tk.PhotoImage(file='./Icon.png'))  # set the window icon
maxwidth = 900
maxheight= 600
root.maxsize(maxwidth, maxheight)  # specify the max size the window can expand to
root.config(bg="skyblue")  # specify background color


# Create left, right and top frames
top_frame = tk.Frame(root, width=maxwidth, height=maxheight/6, bg='grey')
top_frame.grid(row=0, column=0, sticky=tk.NSEW)
bottom_frame = tk.Frame(root, width=maxwidth, height=maxheight/6*5, bg="skyblue")
bottom_frame.grid(row=1, column=0, sticky=tk.NSEW)
left_frame = tk.Frame(bottom_frame, width=maxwidth/3, height=maxheight/6*5, bg='grey')
left_frame.grid(row=0, column=0, padx=10, pady=5)
right_frame = tk.Frame(bottom_frame, width=maxwidth/3*2, height=maxheight/6*5, bg='grey')
right_frame.grid(row=0, column=1, padx=10, pady=5, sticky=tk.NSEW)

# Create frames and labels in left_frame
tk.Label(left_frame, text="Image Generation Parameters").grid(row=0, column=0, padx=5, pady=5)

# path for the main image
filename = parallax.image_filename(1, 1)
image = tk.PhotoImage(file='Altered/'+filename)


# load images to be displayed
def image_update(buffer):
    global S1
    sl1 = S1.get()
    global S2
    sl2 = S2.get()
    global filename
    filename = parallax.image_filename(sl1, sl2)
    filename = 'Altered/' + filename
    global image
    image = tk.PhotoImage(file=filename)
    global mainIm
    mainIm = tk.Label(slide_image, image=image)
    mainIm.grid(row=1, column=0, padx=5, pady=5)


# Display toolbar in top_frame
top_frame.columnconfigure(0, weight=1)
top_frame.columnconfigure(1, weight=1)
top_frame.columnconfigure(2, weight=1)
top_frame.columnconfigure(3, weight=1)
top_frame.rowconfigure(0, weight=1)

tk.Label(top_frame, text="Tool Bar").grid(row=0, column=0, sticky=tk.NSEW)
tk.Label(top_frame, text="Parallax", relief=tk.RAISED).grid(row=0, column=1, sticky=tk.NSEW)
tk.Label(top_frame, text="HDR", relief=tk.RAISED).grid(row=0, column=2, sticky=tk.NSEW)
tk.Label(top_frame, text="Depth", relief=tk.RAISED).grid(row=0, column=3, sticky=tk.NSEW)

# Display light field draggable image in right_frame
slide_image = tk.Frame(right_frame, width=180, height=180)
slide_image.grid(row=1, column=0, padx=5, pady=5)
# top slider
S1 = tk.Scale(slide_image, from_=1, to=9,  orient=tk.HORIZONTAL, length=parallax.im_size(), command=image_update)
S1.grid(row=0, column=0, padx=5, pady=5)
# right slider
S2 = tk.Scale(slide_image, from_=1, to=9, length=parallax.im_size(), command=image_update)
S2.grid(row=1, column=1, padx=5, pady=5)

# main image
mainIm = tk.Label(slide_image, image=image)
mainIm.grid(row=1, column=0, padx=5, pady=5)


# Create parallax parameters frame
par_par = tk.Frame(left_frame, width=500, height=185)
par_par.grid(row=1, column=0, padx=5, pady=5)

# Example labels that serve as placeholders for other widgets
tk.Label(par_par, text="Inputs", relief=tk.RAISED).grid(row=0, column=0, padx=5, pady=3, ipadx=10)
tk.Label(par_par, text="Viewing", relief=tk.RAISED).grid(row=0, column=1, padx=5, pady=3, ipadx=10)

# Example labels that could be displayed under the "Tool" menu
tk.Label(par_par, text="File Location of Images").grid(row=1, column=0, padx=5, pady=5)
tk.Entry(par_par).grid(row=1, column=1, padx=5, pady=5)

root.mainloop()
