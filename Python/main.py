# GUI FOR LIGHT FIELD IMAGE VIEWING #

# import tkinter and all its functions
import tkinter as tk
import functions

# resize all the images in the set
functions.im_resize()

root = tk.Tk()  # create root window
root.title("Light Field Imaging GUI")  # title of the GUI window
root.iconphoto(False, tk.PhotoImage(file='./Icon.png'))  # set the window icon
root.maxsize(900, 600)  # specify the max size the window can expand to
root.config(bg="skyblue")  # specify background color

# Create left and right frames
left_frame = tk.Frame(root, width=200, height=400, bg='grey')
left_frame.grid(row=0, column=0, padx=10, pady=5)
right_frame = tk.Frame(root, width=650, height=400, bg='grey')
right_frame.grid(row=0, column=1, padx=10, pady=5)

# Create frames and labels in left_frame
tk.Label(left_frame, text="Image Generation Parameters").grid(row=0, column=0, padx=5, pady=5)

# path for the main image
filename = functions.image_filename(1, 1)
image = tk.PhotoImage(file='Altered/'+filename)


# load images to be displayed
def image_update(buffer):
    global S1
    sl1 = S1.get()
    global S2
    sl2 = S2.get()
    global filename
    filename = functions.image_filename(sl1, sl2)
    filename = 'Altered/' + filename
    global image
    image = tk.PhotoImage(file=filename)
    global mainIm
    mainIm = tk.Label(slide_image, image=image)
    mainIm.grid(row=1, column=0, padx=5, pady=5)


# Display light field draggable image in right_frame
slide_image = tk.Frame(right_frame, width=180, height=185)
slide_image.grid(row=1, column=1, padx=5, pady=5)
# top slider
S1 = tk.Scale(slide_image, from_=1, to=9,  orient=tk.HORIZONTAL, length=functions.im_size(), command=image_update)
S1.grid(row=0, column=0, padx=5, pady=5)
# right slider
S2 = tk.Scale(slide_image, from_=1, to=9, length=functions.im_size(), command=image_update)
S2.grid(row=1, column=1, padx=5, pady=5)

# main image
mainIm = tk.Label(slide_image, image=image)
mainIm.grid(row=1, column=0, padx=5, pady=5)


# Create toolbar frame
tool_bar = tk.Frame(left_frame, width=500, height=185)
tool_bar.grid(row=1, column=0, padx=5, pady=5)

# Example labels that serve as placeholders for other widgets
tk.Label(tool_bar, text="Inputs", relief=tk.RAISED).grid(row=0, column=0, padx=5, pady=3, ipadx=10)
tk.Label(tool_bar, text="Viewing", relief=tk.RAISED).grid(row=0, column=1, padx=5, pady=3, ipadx=10)

# Example labels that could be displayed under the "Tool" menu
tk.Label(tool_bar, text="File Location of Images").grid(row=1, column=0, padx=5, pady=5)
tk.Entry(tool_bar).grid(row=1, column=1, padx=5, pady=5)

root.mainloop()
