clear all; close all; clc;

%-----------------------------------------------------------------
%This path contains readHypImg and Hyperspectral Images
%-----------------------------------------------------------------
addpath('/home/jairo/Documentos/OCTAVE/SyntheticData/Sample2Modified/');

%-----------------------------------------------------------------
%Actual Hyperimage
%-----------------------------------------------------------------
imgDir  = '/home/jairo/Documentos/OCTAVE/SVM2/VARS/';
imgPath = [imgDir 'TE3_Denoised.mat'];

%-----------------------------------------------------
%Obtain Hyperspectral Image
%-----------------------------------------------------
rows    = 200;
cols    = 200;
L       = 224;
K       = 5;
asACube = 1;
load(imgPath);%Asume que esta normalizada

%X2      = matrix2Cube(X,rows,cols,224);
X2      = matrix2Cube(D,rows,cols,224);
%X2      = reducedCube;

%imshow( squeeze(X2(:,:,1)) );


%rows      = 1;
%cols      = 3;
%L         = 3;
%X2        = zeros(rows,cols,L);
%X2(1,1,:) = [1;0.0001;0.0001];
%X2(1,2,:) = [1,0.0001,0];
%X2(1,3,:) = [1,0,0.0001];





%-----------------------------------------------------
%SMV2
%-----------------------------------------------------

%Define Container
E   = zeros(L,K);
rcE = zeros(2,K);
H   = zeros(1,K);

tic;
%.....................................................
%Obtain the largest Spectral Pixel
%.....................................................
maxLength = 0;
for c=1:cols 
  for r=1:rows
    specPix   = squeeze(X2(r,c,:));
    tmpLength = norm(specPix);
    if tmpLength > maxLength
      maxLength = tmpLength;
      cMax      = c;
      rMax      = r;
    end
  end
end
specPix   = squeeze(X2(rMax,cMax,:));
H(1)      = norm(specPix);
E(:,1)    = specPix / norm(specPix);
rcE(1,1)  = rMax;
rcE(2,1)  = cMax;

%.....................................................
%Obtain Remainder Endmembers
%.....................................................
for k=2:K
  maxLength     = 0;
  lastEndmember = E(:,k-1);
  for c=1:cols 
    for r=1:rows
      specPix   = squeeze(X2(r,c,:));
      specPix   = specPix - ( ( dot(specPix,lastEndmember) / dot(lastEndmember,lastEndmember) ) * lastEndmember);
      X2(r,c,:) = specPix;
      tmpLength = norm(specPix);
      if( tmpLength > maxLength )
        maxLength = tmpLength;
        cMax      = c;
        rMax      = r;
      end
    end
  end
  specPix   = squeeze(X2(rMax,cMax,:));
  H(k)      = norm(specPix);
  E(:,k)    = specPix / norm(specPix);
  rcE(1,k)  = rMax;
  rcE(2,k)  = cMax;
end
toc;

vol = 0;
for k=K:-1:2
  vol = vol + ( H(k) * H(k-1) );
endfor
vol = vol

imgPath

rcE'
























