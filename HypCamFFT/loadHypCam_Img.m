clear all; close all; clc;

%========================================================
%Prepare for XML reading
%========================================================
javaaddpath ("/usr/share/java/xercesImpl.jar");
javaaddpath ("/usr/share/java/xml-apis.jar");
pkg load io; 

%========================================================
%Get Cube Data
%========================================================
path        = "/home/jairo/Documentos/DESARROLLOS/build-HypCam-Desktop_Qt_5_8_0_GCC_64bit-Release/tmpImages/frames/testHypCube/";
fileName    = [path "slideHypcube.hypercube"]
parser = javaObject('org.apache.xerces.parsers.DOMParser');
parser.parse([path "info.xml"]); % it seems that cd in octave are taken into account
xDoc        = parser.getDocument;
elem        = xDoc.getElementsByTagName('hypcubeW').item(0);
W           = str2num(elem.getFirstChild.getTextContent);
elem        = xDoc.getElementsByTagName('hypcubeH').item(0);
H           = str2num(elem.getFirstChild.getTextContent);
elem        = xDoc.getElementsByTagName('hypcubeL').item(0);
L           = str2num(elem.getFirstChild.getTextContent);
elem        = xDoc.getElementsByTagName('initWavelength').item(0);
cubeSpecIni = elem.getFirstChild.getTextContent;
elem        = xDoc.getElementsByTagName('spectralResolution').item(0);
cubeSpecRes = elem.getFirstChild.getTextContent;

%========================================================
%Get HypCube
%========================================================
N           = W*H*L;
img         = fopen(fileName,"r","ieee-le");
lineImg     = fread(fileName,N,"uint8");
fclose(img);
X           = reshape( lineImg, [L H W] );

%========================================================
%Display Imagery
%========================================================
if 1
  for l=1:1:L
    figure(l);
    imshow( squeeze( X(l,:,:) )/255.0 );
  end
end

