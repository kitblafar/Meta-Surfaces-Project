# Plenoptic HDR Metalenses

The aim of this project was to create a set of software that could generate geometry maps for metalenses to create HDR, depth sensed (plenoptic) images, this would require full phase (for focusing) and amplitude (for exposure) control. A metalens is a lens that uses micro-pillars on a substrate to control light that passes through it. Wide pillars in the center of a meta lens and thin pillar on the edge would produce a convex lens equivalent. This project uses a simulated Micro-MetaLens (MML) Array, to capture the varying position (for depth) and varying exposure (for HDR) instantaneously (in a single shutter), this would allow depth sensing on moving object and remove HDR artifacts like ghosting.

## Simulation
CST microwave studio results linking pillar rotation and geometry to output phase. Changing the amplitude was found to be possible by changing the polarisation of the light and applying a different polarising filters to the sensor. The polarisation of the light can be changed by varying the width and breath of an elliptical pillar. Changing the phase is done by changing the rotation of the given pillar geometry. The three variables changed in testing (x-radius, y-radius and rotation) of a pillar where changed. An example pillar is shown below where the green is the substrate.

![CST test pillar](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figure-%20CST/PolarisedPil.png)

## Map Generation
A phase mapping program for MATLAB including a UI that maps pillar rotation and geometry to phase change in a metalens to allow for full metalens phase map generation. The GUI is shown below and produces a visual representation of the phase map as well as a GDS map (GDSII) that can be used for fabrication. This program takes lens parameters, generates an equivalent phase map (amplitude of constant across the lens) and a list of locations for pillars. The list of locations is then gone through and the phase at that location found, the simulation data is then used like a LUT and the required geometry for that phase and amplitude is subbed in.

![MATLAB GUI](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figures-%20MATLAB/GUI%20Screenshot.PNG)

## Map Validation

The center line of some small generated maps where then put back into CST studio and heat-maps were produced. These maps showed both focusing and amplitude control.

![A row of pillars](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figure-%20CST/Full%20row%20r1%3D190%20r2%3D165%20r3%3D145%20r4%3D115%20r595%20h2%3D3200.png)
![Amplitude control phase map](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figure-%20CST/Single%20Line%20Intesity%20Zmax(1)_new.png)

## Blender Model Creation

Due to COVID, the lab was closed so the lens could not be fabricated. In order to carry on with the image processing section of the project, a Blender equivalent model of the lenses was made.

![Produced image no absorption](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Blender/NewCamera/threemonkeys.png)
![Camera setup](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figures-%20Python/AddOn%20Plenoptic%20Setup.PNG)

## Image Reconstruction

Using the Blender images, a Tkinter Python app was made to process these images using HDR and into a map that predicts the depth of each object. 

### Depth Sensing: 
Each object, which we wanted to know the of should be seperated from each other image. First the image was contoured to guess at the border of each object, the objects where then classified by colour. As the distance of the sensor from the lens; the distance between each lens in the array and the location of the object in each image are known, then the distance between the lens and the object or the "depth" can be triangulated. This was done and the heatmap generated.

![Heatmap of depth](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figures-%20Python/Depth/heatmap.png)

### HDR: 
This reconstruction was less successful due to the lens distortion on images as the edge of the MML array but both Debevec and Robertson algorithms were used on the image set.

![Input Image Set](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figures-%20Python/HDR/HDRCollage.png)

![HDR image from Debevec](https://github.com/kitblafar/Meta-Surfaces-Project/blob/main/Figures-%20Python/HDR/Debevec.png)
