clear all; close all; clc;

%Select Parameter for the selected image
imgSelected = "1_PiedraCasaSiembra_Reduced";
selectImageParameter;

%Load Image 1:Cube | 2:Matrix | 3:Vector
%Image is saved into X
type = 2;
loadHypercube;

%Calc Eigenvalues
[U S V]   = svd(cov(X));
eigvalue  = max(S)';

%Select Dimensionality
nombre = [tmpPath srcPath "/__Originals/dimSel.png"];
ADR2018