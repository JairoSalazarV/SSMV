clear all; close all; clc;

%==================================================
% Read HypImg
%==================================================
cual    = 'TI2_2';
asACube = 0;
divide  = 0;
getHypImgParams;

%==================================================
% Noise estimation algorithm
%==================================================
Y           = X';% Y = LxN Matrix
Z           = Y';
Rg          = (Z'*Z)+1;
[N,L]       = size(Z);
E           = zeros(N,L);
  
if( det(Rg) != 0 )
  Rp          = inv(Rg);

  %Rp          = ~isnan(Rp);
  %lstInfs     = find( isinf(Rp) );
  %Rp          = isinf(Rp);

  for i=1:1:L
      %Obtain the R matrix segments A, b, c an b'
      Ac      = [ Rp(:,1:(i-1)), Rp(:,(i+1):L) ]; 
      A       = [ Ac(1:(i-1),:) ; Ac((i+1):L,:) ];
      b       = [ Rp(1:(i-1),i) ; Rp((i+1):L,i) ]; 
      bg      = [ Rg(1:(i-1),i) ; Rg((i+1):L,i) ];    
      c       = Rp(i,i);
      Bi      = (A-((b*b')/c) ) * bg;
      Zp      = [Z(:,1:i-1), Z(:,(i+1):L)];
      zi      = Z(:,i);    
      E(:,i)  = zi - (Zp*Bi);
  end
end

%==================================================
% Save Noise Estimated
%==================================================
save(['./VARS/' cual '_Noise.mat'],'E');
