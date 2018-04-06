clear all; close all; clc;

%-----------------------------------------------------------------
%This path contains readHypImg and Hyperspectral Images
%-----------------------------------------------------------------
addpath('/home/jairo/Documentos/OCTAVE/SyntheticData/Sample2Modified/');

%-----------------------------------------------------------------
%Actual Hyperimage
%-----------------------------------------------------------------
%tmgName = 'TI2';
tmgName = 'TI2';
imgDir  = '/home/jairo/Documentos/OCTAVE/SVM2/VARS/';
imgPath = [imgDir tmgName];

%-----------------------------------------------------
%Obtain Hyperspectral Image
%-----------------------------------------------------
rows    = 200;
cols    = 200;
L       = 224;
K       = 5;
asACube = 1;
load(imgPath);%Asume que esta normalizada
%X       = matrix2Cube(D,rows,cols,L);
X       = matrix2Cube(X,rows,cols,L);
%X       = reducedCube;

%-----------------------------------------------------
%Define Spectral Pixels to Extract
%-----------------------------------------------------
%Reference
xyR = [30,30;30,60;30,90;30,120;30,150];

%xyO = [30,90;30,150;30,120;30,60;30,30];%TI1
%xyO = [30,90;35,9;9,196;28,100;152,23];%TI2
%xyO = [61,90;32,123;91,150;32,151;33,32];%TI3

%xyO = [30,90;30,150;30,120;30,60;30,30];%TE1
%xyO = [30,90;30,150;182,59;162,39;167,153];%TE2
%xyO = [30,91;33,61;31,123;30,152;60,60];%TE3

%xyO = [30,90;30,150;30,120;30,60;30,30];%TI1_Denoised
%xyO = [30,90;30,150;73,132;114,57;61,163];%TI2_Denoised
%xyO = [61,90;60,151;90,91;91,90;32,33];%TI3_Denoised

%xyO = [30,90;30,150;30,120;30,60;30,30];%TE1_Denoised
%xyO = [30,90;30,150;182,59;162,39;167,153];%TE2_Denoised
%xyO = [30,91;33,61;31,123;30,152;60,60];%TE3_Denoised

%xyO = [30,90;30,120;30,30;30,150;30,60];%TI1_svd_reducedCube
%xyO = [30,60;60,165;111,156;155,200;193,179];%TI2_svd_reducedCube
%xyO = [30,62;30,153;9,91;33,91;55,174];%TI3_svd_reducedCube

%xyO = [30,90;30,150;30,120;30,60;30,30];%TE1_svd_reducedCube
%xyO = [30,90;30,150;39,80;171,181;161,53];%TE2_svd_reducedCube
%xyO = [30,91;31,63;31,150;90,30;12,56];%TE3_svd_reducedCube

%xyO = [30,90;30,150;73,132;114,57;163,61];%TI2 Sin Ruido

%xyO = [30,91;31,91;31,90;61,91;61,90];%OBA TI1
%xyO = [];%OBA TI2
%xyO = [];%OBA TI3

%xyO = [90,31;91,31;90,30;91,30;30,32];%NFINDR TI1
xyO = [109,26;80,5;76,15;117,28;165,32];%NFINDR TI2

if(0)
  E_R = [squeeze(X(xyR(1,2),xyR(1,1),:)),squeeze(X(xyR(2,2),xyR(2,1),:)),squeeze(X(xyR(3,2),xyR(3,1),:)),squeeze(X(xyR(4,2),xyR(4,1),:)),squeeze(X(xyR(5,2),xyR(5,1),:))];
  E_O = [squeeze(X(xyO(1,2),xyO(1,1),:)),squeeze(X(xyO(2,2),xyO(2,1),:)),squeeze(X(xyO(3,2),xyO(3,1),:)),squeeze(X(xyO(4,2),xyO(4,1),:)),squeeze(X(xyO(5,2),xyO(5,1),:))];
  volR = (1/factorial(K-1))*abs(det(E_R))
  volO = (1/factorial(K-1))*abs(det(E_O))
  ratio1 = volO / volR
end

%.....................................................
%Obtaining Heights by Orthogonalization
%.....................................................
%Get Endmembers and Reference
ER  = zeros(L,K);
EO  = zeros(L,K);
for k=1:K
  ER(:,k)  = squeeze(X(xyR(k,2),xyR(k,1),:));
  EO(:,k)  = squeeze(X(xyO(k,2),xyO(k,1),:));
end

%Usando Ruis Gil | Distancia entre subvariedades lineales afines
if(1)
  ER2   = ER';
  EO2   = EO';
  volR  = sqrt(det(ER2*ER2'))
  volO  = sqrt(det(EO2*EO2'))
  ratio = volO / volR
end

%Usando QR decompition
if(0)
  [qR, rR]  = qr(ER);
  [qO, rO]  = qr(EO);
  volR      = (1/factorial(K-1))*norm(rR(:,1))*norm(rR(:,2))*norm(rR(:,3))*norm(rR(:,4))*norm(rR(:,5))
  volO      = (1/factorial(K-1))*norm(rO(:,1))*norm(rO(:,2))*norm(rO(:,3))*norm(rO(:,4))*norm(rO(:,5))
  ratioQR   = volO / volR
end
%Usando complementos mgorth
if(0)
  HR    = squeeze(ER(:,1));
  HO    = squeeze(EO(:,1));
  volR  = norm(HR);
  volO  = norm(HO);
  HR    = orth(ER(:,1));
  HO    = orth(EO(:,1));
  for k=2:K
    xR    = squeeze(ER(:,k));
    xO    = squeeze(EO(:,k));
    hR    = mgorth(HR, xR);
    hO    = mgorth(HO, xO);
    volR  = [volR norm(xR)];
    volO  = [volO norm(xO)];
    HR    = orth(ER(:,1:k));
    HO    = orth(EO(:,1:k));
  end
end
%Usando SVD con los eigenvalues como alturas h
if(0)
  [U, SR, V] = svd(ER);
  [U, SO, V] = svd(EO);
  volR  = norm(max(SR))
  volO  = norm(max(SO))
  ratio = volO/volR
end

%%Usando complementos ortogonales con Stable Gram-Schmidt
if(0)
  %Orthogonalization
  HR  = zeros(L,K);
  HO  = zeros(L,K);
  HRU = zeros(L,K);
  HOU = zeros(L,K);
  HR(:,1)  = ER(:,1)/sqrt(ER(:,1)'*ER(:,1));
  HO(:,1)  = EO(:,1)/sqrt(EO(:,1)'*EO(:,1));
  HRU(:,1) = ER(:,1);
  HOU(:,1) = EO(:,1);
  for k=2:K
    HR(:,k) = ER(:,k);
    HO(:,k) = EO(:,k);
    for j=1:k-1
      HR(:,k) = HR(:,k) - ( HR(:,k)'*HR(:,j) )/( HR(:,j)'*HR(:,j) )*HR(:,j);
      HO(:,k) = HO(:,k) - ( HO(:,k)'*HO(:,j) )/( HO(:,j)'*HO(:,j) )*HO(:,j);
    end
    HRU(:,k) = HR(:,k);
    HOU(:,k) = HO(:,k);
    HR(:,k)  = HR(:,k)/sqrt(HR(:,k)'*HR(:,k));
    HO(:,k)  = HO(:,k)/sqrt(HO(:,k)'*HO(:,k));  
  end
  %Volume Calculating
  volR = 0;
  volO = 0;
  for k=1:K
    volR = volR + norm(HRU(:,k));
    volO = volO + norm(HOU(:,k));
  end
  volR   = volR
  volO   = volO
  ratio2 = volO / volR
end
  


%-----------------------------------------------------
%Display Spectral
%-----------------------------------------------------
h1 = figure('name','Image');
imshow( squeeze(X(:,:,1)) );
hold on;
labelO = ["a","b","c","d","e","f"];
for k=1:K
  text(xyR(k,1)-7,xyR(k,2),mat2str(k),'fontsize',20,'color','r');
  text(xyO(k,1)+5,xyO(k,2),labelO(k),'fontsize',20,'color','b');
  text(xyO(k,1),xyO(k,2),"x",'fontsize',14,'color','b');
  text(xyR(k,1),xyR(k,2),"o",'fontsize',16,'color','r');
endfor
title('(1-5) Endmember Location. (a-e) Endmember Extracted.');
saveas(h1, ["./FIGURES/SMV_EXTRACTION/" tmgName "_Img.png"]);

%-----------------------------------------------------
%Plot Signatures
%-----------------------------------------------------
h2 = figure('name','Reference'); 
plot(ER);
title('Expected Endmembers');

h3 = figure('name','Other'); 
plot(EO);
title('Extracted Endmembers');

saveas(h2, ["./FIGURES/SMV_EXTRACTION/" tmgName "_SignExpected.png"]);
saveas(h3, ["./FIGURES/SMV_EXTRACTION/" tmgName "_SignSMV.png"]);

%-----------------------------------------------------
%Plot Volumes
%-----------------------------------------------------
h4 = figure('name','Volumes'); 
x = [volR volO];
str = {['Expected (' mat2str(floor(volR*100)/100) ')']; ['Extracted (' mat2str(floor(volO*100)/100) ')']};
h5 = bar(x/x(1),"facecolor","black");
title('Simplexes Volume');
set(gca,'XTickLabel',str,'XTick',1:numel(str));
saveas(h4, ["./FIGURES/SMV_EXTRACTION/" tmgName "_Volume.png"]);