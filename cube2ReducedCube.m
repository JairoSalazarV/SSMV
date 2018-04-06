clear all; close all; clc;

origin  = 'TI2_2_Denoised_svd';
W       = 200;
H       = 200;
L       = 5;
load(['./VARS/' origin '.mat']);



X2Work      = XReduced;% XReduced | D
i           = 1;
reducedCube = zeros(W,H,L);
for x=1:W
  for y=1:H
    reducedCube(x,y,1:L) = squeeze( X2Work(i,1:L) );
    i = i + 1;
  endfor
endfor

outFilename = ['./VARS/' origin '_reducedCube.mat'];
save( outFilename, 'reducedCube' );

imshow( reducedCube(:,:,1)/max(max(max(reducedCube))) );




