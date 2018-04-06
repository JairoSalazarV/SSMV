clear all; close all; clc;

%-----------------------------------------------------------------
%Get Reduced Hypercub as a matrix Nxk
%-----------------------------------------------------------------

%Select Parameter for the selected image
imgSelected = "1_PiedraCasaSiembra";
selectImageParameter;

%Load Enviroment
load([ "./VARS/" imgSelected ".m" ]);

%Reshape Cube
X2 = reshape(X,H,W,L);
for i=1:L
  X2(:,:,i) = X2(:,:,i)';
endfor

if 0
  imshow(X2(:,:,60));
endif
  
addpath("./NFINDR/");
for i=1:1
  [endmemberindex duration] = NFINDR(X2,K)
endfor
imgPath

colRow = endmemberindex

