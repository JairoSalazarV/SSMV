N           = W*H*L;
img         = fopen(imgPath,"r","ieee-le");
lineImg     = fread(img,N,"uint16")/12000;

if( type == 1 )%Cube
  X         = reshape(lineImg,[L,(W*H)])';
  X         = matrix2Cube(X,H,W,L);
endif

if( type == 2 )%Matrix
  X         = reshape(lineImg,[L,(W*H)])';
endif

if( type == 3 )%Vector
  X         = lineImg;
endif