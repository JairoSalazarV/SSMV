clear all; close all; clc;

%-----------------------------------------------------------------
%Get Reduced Hypercub as a matrix Nxk
%-----------------------------------------------------------------

%Select Parameter for the selected image
imgSelected = "1_PiedraCasaSiembra";
selectImageParameter;

%Load Enviroment
load([ "./VARS/" imgSelected "_Reduced.m" ]);

%Reshape Cube
X2 = reshape(X,H,W,K);
for i=1:K
  X2(:,:,i) = X2(:,:,i)';
endfor

%Serialize Matrix
imageSerialized = zeros(K,(W*H));
i = 1;
for r=1:H
  for c=1:W
    imageSerialized(:,i) = X2(r,c,:);
    i++;
  endfor  
endfor


%-----------------------------------------------------------------
%Get Reduced Hypercub as a matrix Nxk
%-----------------------------------------------------------------

addpath("./OBA/");
[endmemberindex duration] = OBA(imageSerialized,K);

rcEndmember = zeros(K,2);
for i=1:K
  index = endmemberindex(i);
  rcEndmember(i,1) = floor(index/W) + 1;              %Row
  rcEndmember(i,2) = index - ((rcEndmember(i,1)-1)*W);%Col
end

imgPath

duration

endmemberindex

rowCol = rcEndmember



