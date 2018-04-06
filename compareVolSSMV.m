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
X = reshape(X,H,W,L);
for i=1:K
  X(:,:,i) = X(:,:,i)';
endfor

%-----------------------------------------------------
%Define Spectral Pixels to Extract
%-----------------------------------------------------
%Reference
if( 1 )
  %Reference
  xyR = [  
          16    47;
          73    95;
          25    25;
          7     104;
          75    116
        ];%SSMV
endif

if( 0 )
  %Reference
  xyR = [  
          16   47;
          65   20;
          95   73;
          117  75;
          46   24
        ];%MANUAL  
endif

if( 0 )
  %Reference
  xyR = [  
          47   16;
          20   65;
          73   95;
          75  117;
          24   46
        ];%MANUAL  
endif

if( 0 )
  xyO = [  
          47   16;
          20   65;
          73   95;
          75  117;
          24   46
        ];%MANUAL  
endif

if( 0 )
  xyO = [  
          65    20;
          25    25;
          117   75;
          95    73;
          46    24
        ];%NFINDR
endif

if( 1 )
  xyO = [  
          20    65;
          25    25;
          75   117;
          73    95;
          24    46
        ];%NFINDR
endif

if( 0 )
  xyO = [  
          16    47;
          73    95;
          25    25;
           7   104;
          75   116
        ];%ATGP
endif
      
if( 0 ) 
  xyO = [  47   16;
           29   24;
           95   73;
           29   23;
           96   70
        ];%OBA
endif
   


      


%.....................................................
%Obtaining Heights by Orthogonalization
%.....................................................
%Get Endmembers and Reference
ER  = zeros(L,K);
EO  = zeros(L,K);
for k=1:K
  ER(:,k)  = squeeze(X(xyR(k,1),xyR(k,2),:));
  EO(:,k)  = squeeze(X(xyO(k,1),xyO(k,2),:));
end


%.....................................................
%COMPARE
%.....................................................

%Usando Ecuación de Winter-NFINDR
if( 1 )
  volR        = (1/factorial(K-1))*abs(det(ER))
  volO        = (1/factorial(K-1))*abs(det(EO))
  ratioWinter = volO / volR
end
   
if(0)
  E_R = [squeeze(X(xyR(1,2),xyR(1,1),:)),squeeze(X(xyR(2,2),xyR(2,1),:)),squeeze(X(xyR(3,2),xyR(3,1),:)),squeeze(X(xyR(4,2),xyR(4,1),:)),squeeze(X(xyR(5,2),xyR(5,1),:))];
  E_O = [squeeze(X(xyO(1,2),xyO(1,1),:)),squeeze(X(xyO(2,2),xyO(2,1),:)),squeeze(X(xyO(3,2),xyO(3,1),:)),squeeze(X(xyO(4,2),xyO(4,1),:)),squeeze(X(xyO(5,2),xyO(5,1),:))];
  volR = (1/factorial(K-1))*abs(det(E_R))
  volO = (1/factorial(K-1))*abs(det(E_O))
  ratio1 = volO / volR
end

%Usando Ruis Gil | Distancia entre subvariedades lineales afines
if(0)
  ER2           = ER';
  EO2           = EO';
  volR          = sqrt(det(ER2*ER2'))
  volO          = sqrt(det(EO2*EO2'))
  ratio_RuisGil = volO / volR
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
if( 0 )
  %Orthogonalization
  HR  = zeros(K,K);
  HO  = zeros(K,K);
  HRU = zeros(K,K);
  HOU = zeros(K,K);
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
    volR  = volR + norm(HRU(:,k));
    volO  = volO + norm(HOU(:,k));
  end
  volR    = volR
  volO    = volO
  ratioCO = volO / volR
end
  


%-----------------------------------------------------
%Display Spectral
%-----------------------------------------------------
tmpImgPath = [tmpPath srcPath "/__Originals/RGBImgSub.png"];
tmpImg = imread(tmpImgPath);
h1 = figure('name','Image');
imshow( tmpImg );
hold on;
labelO = ["a","b","c","d","e","f"];
aux = -1;
for k=1:K
  %text(xyR(k,1)+(4*aux),xyR(k,2)+(4*aux),mat2str(k),'fontsize',20,'color','r');
  %text(xyO(k,1)+5,xyO(k,2),labelO(k),'fontsize',20,'color','b');
  %text(xyO(k,1),xyO(k,2),"x",'fontsize',14,'color','b');
  text(xyR(k,1),xyR(k,2),"x",'fontsize',16,'color','r');
  aux = aux*-1;
endfor
title(["(1-" int2str(K) ") Endmember Location"]);
saveas(h1, [tmpPath srcPath "/__Originals/SSMVEndmembers.png"],"png");

%-----------------------------------------------------
%Plot Signatures
%-----------------------------------------------------
h2 = figure('name','Reference'); 
plot(ER);
title('Expected Endmembers');

h3 = figure('name','Other'); 
plot(EO);
title('Extracted Endmembers');

saveas(h2, ["./FIGURES/SMV_EXTRACTION/" imgSelected "_SignExpected.png"]);
saveas(h3, ["./FIGURES/SMV_EXTRACTION/" imgSelected "_SignSMV.png"]);

%-----------------------------------------------------
%Plot Volumes
%-----------------------------------------------------
h4 = figure('name','Volumes'); 
x = [volR volO];
str = {['SSMV (' mat2str(floor(volR*100)/100) ')']; ['Otro (' mat2str(floor(volO*100)/100) ')']};
h5 = bar(x/x(1),"facecolor","black");
title('Simplexes Volume');
set(gca,'XTickLabel',str,'XTick',1:numel(str));
saveas(h4, ["./FIGURES/SMV_EXTRACTION/" imgSelected "_Volume.png"]);