
 
if( strcmp(imgSelected, "1_PiedraCasaSiembra") )
  W           = 150;
  H           = 150;
  L           = 224;
  K           = 5;
  srcPath     = "1_PiedraCasaSiembra";
endif

if( strcmp(imgSelected, "1_PiedraCasaSiembra_Reduced") )
  W           = 150;
  H           = 150;
  L           = 5;
  K           = 5;%After calculate using plotEigenvalues.m
  srcPath     = "1_PiedraCasaSiembra";
endif


tmpPath = "/home/jairo/Documentos/HypIDE/IEEE2018/";
imgPath = [tmpPath srcPath "/__Originals/HypImgSub.hyp"];
