clear all; close all; clc;
pkg load image;

i = 1;
plotRows = 3;
plotCols = 2;

a   = double(imread('tstImg.png','png'));

axis image;

[Y,X,L] = size(a);
a       = rgb2gray(a);
%a       = a(1:Y,4001:4500);
%[Y,X,L] = size(a)

subplot(plotRows, plotCols, i++);
imagesc(a);
colormap(gray);
title("Orig Subimage");


A = fft2(a);
subplot(plotRows, plotCols, i++);
imagesc(log(abs(A)));
title("FFT");

B = fftshift(A);
subplot(plotRows, plotCols, i++);
imagesc(log(abs(B)));
title("FFT, Shift");

C  = B;
mX = round(X/2);
mY = round(Y/2);
W  = round((X*0.13));
H  = 7;
C(mY-H:mY+H,1:mX-round(W/2)) = 0;
C(mY-H:mY+H,mX+round(W/2):X) = 0;

subplot(plotRows, plotCols, i++);
imagesc(log(abs(C)));
title("FFT, Filtered");

D = ifftshift(C);
subplot(plotRows, plotCols, i++);
imagesc(log(abs(D)));
title("FFT, Inverted Shift");

E = ifft2(D);
subplot(plotRows, plotCols, i++);
imagesc(abs(E));
title("FFT, Recupered Image");

