clear all; close all; clc;

%-----------------------------------------------------------------
%Get Reduced Hypercub as a matrix Nxk
%-----------------------------------------------------------------

%Select Parameter for the selected image
imgSelected = "1_PiedraCasaSiembra_Reduced";
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


imagecube                   = X2;
bands                       = L;
p                           = K;

%===========================================
% ATGP CHE I. CHANG
% Return: [x,y] pixels coordinates
%===========================================
addpath("./ATGP/");
tic;
[xyEndmembers lstEndmembers duration]= ATGP(p,imagecube,W,H,bands);
toc;

imgPath

colRow = xyEndmembers




