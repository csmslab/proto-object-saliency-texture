Proto-Object Based Visual Saliency Model with Simple Texture (MATLAB code)

Takeshi Uejima, uejima.takeshi@gmail.com / tuejima1@jhu.edu
Johns Hopkins University

This model is based on Russell et al. model and includes a simple texture channle with 2D Gaussin filter.
The detail is written in T. Uejima, E. Niebur, and R. Etienne-Cummings. "Proto-Object Based Saliency Model with Second-Order Texture Feature", BioCAS2018.

===============================================================================
How to Use

(1) Add the folder of "ProtoObjectSaliencyTexture" and its subfolders to your MATLAB path.
(2) Run "result=runProtoSalTex('filename','ICOR')"
    The first argue is the input file name.
    The second argue is the channels to use for calculating saliency. I: Intensity, C: Color, O: Orientation, R: Texture.
    The output is a structure and its "data" field is the predicted saliency.
*"runProtoSalCAT2000" is a modified code to process the images of CAT2000. This code remove the gray margins of the images before feeding them to the algorithm.
 This is how we have processed the CAT2000 images in the conference paper of BioCAS2018.

===============================================================================
References

1. T. Uejima, E. Niebur, and R. Etienne-Cummings, “Proto-Object Based Saliency Model with Second-Order Texture Feature,” in 2018 IEEE Biomedical Circuits and Systems Conference (BioCAS), 2018, pp. 1–4.
2. A. F. Russell, S. Mihalaş, R. von der Heydt, E. Niebur, and R. Etienne-Cummings, “A model of proto-object based saliency,” Vision Res., vol. 94, pp. 1–15, 2014.