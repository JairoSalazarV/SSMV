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
X2(:,:,L) = ones(W,H);

%-----------------------------------------------------
%SMV2
%-----------------------------------------------------

%Define Container
E       = zeros(L,K);
rcE     = zeros(2,K);
Heighs  = zeros(1,K);

tic;
%.....................................................
%Obtain the largest Spectral Pixel
%.....................................................
maxLength = 0;
for c=1:W 
  for r=1:H
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
Heighs(1) = norm(specPix);
E(:,1)    = specPix / norm(specPix);
rcE(1,1)  = rMax;
rcE(2,1)  = cMax;

%.....................................................
%Obtain Remainder Endmembers
%.....................................................
for k=2:K
  maxLength     = 0;
  lastEndmember = E(:,k-1);
  for c=1:W 
    for r=1:H
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
  Heighs(k) = norm(specPix);
  E(:,k)    = specPix / norm(specPix);
  rcE(1,k)  = rMax;
  rcE(2,k)  = cMax;
end
toc;

vol = 0;
for k=K:-1:2
  vol = vol + ( Heighs(k) * Heighs(k-1) );
endfor
vol = vol

imgPath

colRow = rcE'





















