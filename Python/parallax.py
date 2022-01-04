# Function to Return the Correct Image Based on Slider Position #
import os
import math
from PIL import Image


# TODO Read the files from the file location given by the user (replace ../TreeScene)
# TODO Use the functions to return variables that define the GUI (mml_size=slider _to, im_size= slider length)

# find MML dimension N (NxN)
def mml_size():
    noMMLs = os.listdir('TreeScene')  # count the number of images available
    noMMLs = int(math.sqrt(len(noMMLs)))
    return noMMLs


# find the dimension of the image (Pixels x Pixels)
def im_size():
    # open first image and read its size
    return Image.open('Altered/'+image_filename(1,1)).size[0]


def im_resize():
    # setting up parameters for crop
    mmlsize = mml_size()
    imagesize = Image.open('TreeScene/'+image_filename(1,1)).size[0]
    squaresize = math.sqrt(imagesize * imagesize / 2) - 3
    diff = int((imagesize - squaresize) / 2)
    box = (diff, diff, (imagesize-diff), (imagesize-diff))
    print(box)
    for i in range(1, mmlsize+1):
        for j in range(1, mmlsize+1):
            filename = image_filename(i, j)
            im = Image.open("./TreeScene/"+filename)
            # crop to square the size of lens
            image = im.crop(box)
            # rotate the images 180 degrees
            transpose = image.transpose(Image.ROTATE_180)
            # save the altered image set
            transpose.save("./Altered/"+filename)

# return the correct image from the file corresponding to the slider value in the form fa_11.png
def image_filename(sl1, sl2):
    col = str(sl1)
    row = str(sl2)
    groupname = os.listdir('TreeScene')[0].partition('_')[0]
    filename = groupname + '_' + row + col + '.png'
    return filename
