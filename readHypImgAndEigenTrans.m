%http://techqa.info/programming/question/33091917/using-pca-to-project-onto-a-lower-dimensional-space-in-octave
%https://stackoverflow.com/questions/33091917/using-pca-to-project-onto-a-lower-dimensional-space-in-octave?rq=1

clear all; close all; clc;
pkg load statistics;

%-----------------------------------------------------------------
%This path contains readHypImg and Hyperspectral Images
%-----------------------------------------------------------------
addpath('/home/jairo/Documentos/OCTAVE/SyntheticData/Sample2Modified/');

%-----------------------------------------------------------------
%Obtain Hyperspectral Image
%-----------------------------------------------------------------
cual    = 'TI2_2_Denoised';
k       = 5;
asACube = 0;
divide  = 0;
getHypImgParams;

%-----------------------------------------------------
%Reduce and Save HypImg
%-----------------------------------------------------
X2Work = X;
tic;
[pcvars XReduced] = princomp(X2Work); % PCA
toc;
save(['./VARS/' cual '_PCA.mat'],'XReduced');
%save(['./VARS/' cual '.mat'],'X');


newX = matrix2Cube(X, rows, cols, L);
imshow(newX(:,:,3)/max(max(max(newX))));


