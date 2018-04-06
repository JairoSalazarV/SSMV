clear all; close all; clc;

%Select Parameter for the selected image
imgSelected = "1_PiedraCasaSiembra";
selectImageParameter;

%Load Image 1:Cube | 2:Matrix | 3:Vector
%Image is saved into X
type = 2;
loadHypercube;

%------------------------
%Reduce dimensions
%------------------------

%Transform X into Relevance Ordered X
[pcvars XReduced] = princomp(X); % PCA
XReduced = XReduced(:,1:K);

%Save Image
Filename  = ["./VARS/" imgSelected ".m"];
save(Filename,'X');
backupX   = X;
X         = XReduced;

%Save Reduced Image
reducedFilename = ["./VARS/" imgSelected "_Reduced.m"];
save(reducedFilename,'X');

%Show image
newX = matrix2Cube(X, H, W, K);
imshow(newX(:,:,3)/max(max(max(newX))));


