if( strcmp(cual,'TI1') || strcmp(cual,'TI2') || strcmp(cual,'TI3') || ...
    strcmp(cual,'TE1') || strcmp(cual,'TE2') || strcmp(cual,'TE3') || ...
    strcmp(cual,'TI2_2') )
  imgPath = ['/home/jairo/Documentos/OCTAVE/SyntheticData/Sample2Modified/SyntheticResult/T/' cual '.hyp'];
  rows    = 200;
  cols    = 200;
  L       = 224;
  X       = double(readHypImg(imgPath,rows,cols,L,asACube));
  if divide
    X     = X / 12000;
  endif
end

if( strcmp(cual,'AVIRIS_MIA') )
  imgPath = ['/home/jairo/Documentos/OCTAVE/SVM2/AVIRISCuprite/MIA/f970619t01p02_r02_sc04.a.rfl'];
  rows    = 200;
  cols    = 200;
  L       = 224;
  X       = double(readHypImg(imgPath,rows,cols,L,asACube));
  X       = X / 10000;
end

if( strcmp(cual,'TI1_svd_reducedCube') || strcmp(cual,'TI2_svd_reducedCube') || strcmp(cual,'TI3_svd_reducedCube') || ...
    strcmp(cual,'TE1_svd_reducedCube') || strcmp(cual,'TE2_svd_reducedCube') || strcmp(cual,'TE3_svd_reducedCube') )
  imgPath = ['/home/jairo/Documentos/OCTAVE/SVM2/VARS/' cual '.mat'];
  load(imgPath);
  rows    = 200;
  cols    = 200;
  L       = 5;
  X       = reducedCube;
end


if( strcmp(cual,'TI2_2_Denoised') )
  imgPath = ['/home/jairo/Documentos/OCTAVE/SVM2/VARS/' cual '.mat'];
  load(imgPath);
  rows    = 200;
  cols    = 200;
  L       = 224;
  X       = D;
end


if( strcmp(cual,'TI2_2_svd') )
  imgPath = ['/home/jairo/Documentos/OCTAVE/SVM2/VARS/' cual '.mat'];
  load(imgPath);
  rows    = 200;
  cols    = 200;
  L       = 224;
  X       = XReduced;
end


if( strcmp(cual,'AVIRIS_Double') )
  load('./AVIRISCuprite/Double_Cuprite_f970619t01p02_r02_sc03.a.rfl.mat');
  X = X/12000;
  [rows, cols, L] = size(X);
  X = D;
end

if( strcmp(cual,'AVIRIS_Original') )
  load('./AVIRISCuprite/Cuprite_f970619t01p02_r02_sc03.a.rfl.mat');
  [rows, cols, L] = size(X);
  cube  = X;
  X     = cube2Matrix(X);  
end

if( strcmp(cual,'AVIRIS') )
  load('./VARS/AVIRIS_Mio_Orig_Cubo.mat');
  [rows, cols, L] = size(cube);
  X     = cube2Matrix(cube);  
end


if( strcmp(cual,'AVIRIS_svd_reducedCube') )
  imgPath = ['/home/jairo/Documentos/OCTAVE/SVM2/VARS/' cual '.mat'];
  load(imgPath);
  rows    = 200;
  cols    = 200;
  L       = 5;
  X       = reducedCube;
end
