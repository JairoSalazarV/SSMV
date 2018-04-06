clear all; close all; clc;

%1-2, 104-113, 148-167, 221-224 becouse low  SNR and vapor absortion

tic;

%===========================================
% OBTAIN DATA
%===========================================
k               = 224;
PseudoType      = 1;
p = 224;
cual = 7;
switch(cual)
    case 8
        cols        = 200;
        rows        = 200;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/Synthetic3/__Oroginals/Hyperspectral.hyp';
    case 7
        cols        = 150;
        rows        = 150;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/ParaSpie2015Proj/__Oroginals/Hyperspectral.hyp';
    case 6
        cols        = 500;
        rows        = 500;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/City500x500/__Oroginals/Hyperspectral.hyp';
    case 5
        cols        = 100;
        rows        = 100;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/Rock100x100/__Oroginals/Hyperspectral.hyp';
    case 4
        cols        = 60;
        rows        = 60;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/Grass60x60/__Oroginals/Hyperspectral.hyp';
    case 3
        cols        = 100;
        rows        = 300;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/Vertical100x300/__Oroginals/Hyperspectral.hyp';
    case 2
        cols        = 100;
        rows        = 100;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/Proj100x100EarthAndGrass/__Oroginals/Hyperspectral.hyp';
    case 1
        cols        = 100;
        rows        = 100;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/ParaOBA1/__Oroginals/Hyperspectral.hyp';
    case 0
        cols        = 20;
        rows        = 20;
        bands       = 224;
        numPix      = cols * rows;
        hypImgPath      = '/home/jairo/Documents/HypIDE/ProjectsV1/Proj_20x20_Small4OBA/__Oroginals/Hyperspectral.hyp';
end


%X               = zeros(rows, cols ,bands);
%for i=1:224
%    posIni   = ((i*bands)-bands)+1;
%    posEnd   = (posIni+bands)-1;
%    X(:,:,i) = multibandread(hypImgPath, [rows cols bands], ...
%                'int16', 0, 'bip', 'ieee-be', ...
%                {'Band', 'Direct', i} );
%end
fileID                      = fopen(hypImgPath,'r');
hypImg                      = fread(fileID, (cols*rows*bands), 'uint16');
fclose(fileID);
imagecube                   = zeros(rows,cols,bands);
for r=0:(rows-1)
    for c=1:cols
        i = (r*cols) + c;
        posIni              = ((i*bands)-bands)+1;
        posEnd              = (posIni+bands)-1;
        imagecube(r+1,c,:)  = hypImg(posIni:posEnd,1)';
    end
end
clear('hypImg');

%X = uint16(X);

%===========================================
% ATGP CHE I. CHANG
% Return: [x,y] pixels coordinates
%===========================================
[xyEndmembers lstEndmembers duration]= ATGP(p,imagecube,cols,rows,bands);
toc;



lstS = [1,1; 1,2; 1,3; 1,4; 1,5; 1,6; 1,7; 1,8; 1,9; 1,10; 1,11];
[numItems two] = size(lstS);
X = zeros(bands,numItems);
for i=1:numItems
    for l=1:bands
        X(l,i) = imagecube(lstS(i,1),lstS(i,2),l);
    end
end





