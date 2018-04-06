clear all; close all; clc;

%-----------------------------------------------------------------
%This path contains readHypImg and Hyperspectral Images
%-----------------------------------------------------------------
addpath('/home/jairo/Documentos/OCTAVE/SyntheticData/Sample2Modified/');

%-----------------------------------------------------------------
%Obtain Hyperspectral Image
%-----------------------------------------------------------------
cual    = 'TI2_2';
asACube = 0;
divide  = 0;
getHypImgParams;
load(['./VARS/' cual '_Noise.mat']);

%-----------------------------------------------------------------
%Denoise and Save Hyperspectral Image
%-----------------------------------------------------------------
D         = X - E;
save(['./VARS/' cual '_Denoised.mat'],'D');



if divide == 0
  tmpMax  = max(max(max(X)));
  D       = D / tmpMax;
  X       = X / tmpMax;
end
newXDenoised  = matrix2Cube( D, rows, cols, L );
newXNoise     = matrix2Cube( X, rows, cols, L );
figure(1); imshow(newXNoise(:,:,20));
figure(2); imshow(newXDenoised(:,:,20));


