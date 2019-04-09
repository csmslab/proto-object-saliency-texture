function [h] = runProtoSalCAT2000(filename,channels)
%Runs the proto-object based saliency algorithm
%This is a modified version for CAT2000 images which have gray margin
%surrounding each image. This script removes the gray margin before feeding
%the input to the algorithm.
%
%inputs:
%filename - filename of image
%channels - channels to use
%               I: Intensity, C: Color, O: Orientation, R: Simple Texture
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012
%Modified by Takeshi Uejima, Johns Hopkins University, 2018

tic
fprintf('Start Proto-Object Saliency')

%generate parameter structure
params = makeDefaultParamsTexture;
%TU
params.channels=channels;
%load and normalize image
%Removing Gray Margin
imOrig=imread(filename);
if size(imOrig,3)==3 %Color
    imgGray=(imOrig(:,:,1)>=121&imOrig(:,:,1)<=131)&(imOrig(:,:,2)>=121&imOrig(:,:,2)<=131)&(imOrig(:,:,3)>=121&imOrig(:,:,3)<=131);
    imgGray=not(imgGray);
    [row,col] = find(imgGray);
    rmax = max(row);rmin = min(row);cmax = max(col);cmin = min(col);
    imgTrim = imOrig(rmin:rmax,cmin:cmax,:);
else
    imgGray=imOrig>=121&imOrig<=131;
    imgGray=not(imgGray);
    [row,col] = find(imgGray);
    rmax = max(row);rmin = min(row);cmax = max(col);cmin = min(col);
    imgTrim = imOrig(rmin:rmax,cmin:cmax);
end
im = normalizeImage(im2double(imgTrim));
%generate feature channels
img = generateChannelsPyramids(im,params);

%generate border ownership structures
[b1Pyr b2Pyr]  = makeBorderOwnership2(img,params);
%generate grouping pyramids
gPyr = makeGrouping(b1Pyr,b2Pyr,params);
CL=7;
t = ittiNorm(gPyr,CL+1);

rowMax=round(size(imOrig,1)/(2^(CL/2)));
colMax=round(size(imOrig,2)/(2^(CL/2)));
dataR=round(rmin/(2^(CL/2)));
if dataR<1
    dataR=1;
end
dataC=round(cmin/(2^(CL/2)));
if dataC<1
    dataC=1;
end

if dataR>1
    h.data(1:round(rmin/(2^(CL/2)))-1,1:colMax)=0;
end
if round(rmax/(2^(CL/2)))<rowMax
    h.data(round(rmax/(2^(CL/2)))+1:rowMax,1:colMax)=0;
end
if dataC>1
    h.data(1:rowMax,1:round(1:cmin/(2^(CL/2)))-1)=0;
end
if round(cmax/(2^(CL/2)))<colMax
    h.data(1:rowMax,round(cmax/(2^(CL/2)))+1:colMax)=0;
end
h.data(dataR:dataR+size(t.data,1)-1,dataC:dataC+size(t.data,2)-1)=t.data;

%Save Saliency
% subplot(1,1,1);imagesc(h.data);colorbar;axis image
% [~,name,~]=fileparts(filename)
% saveas(gcf,['Result_',name,'.png'])
% saveas(gcf,['Result_',name,'.fig'])
% save(['Result_',name,'.mat'],'h');
toc
fprintf('\nDone\n')