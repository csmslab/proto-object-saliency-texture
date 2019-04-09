function [h] = runProtoSalTex(filename,channels)
%Runs the proto-object based saliency algorithm
%
%inputs:
%filename - filename of image
%channels - channels to use
%               I: Intensity, C: Color, O: Orientation, R: Simple Texture
%By Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012
%Modified by Takeshi Uejima, Johns Hopkins University, 2018

tic
fprintf('Start Proto-Object Saliency')
%generate parameter structure
params = makeDefaultParamsTexture;
%Select channels to use
params.channels=channels;
%load and normalize image
im = normalizeImage(im2double(imread(filename)));
%generate feature channels
img = generateChannelsPyramids(im,params);

%generate border ownership structures
[b1Pyr b2Pyr]  = makeBorderOwnership2(img,params);
%generate grouping pyramids
gPyr = makeGrouping(b1Pyr,b2Pyr,params);

%normalize grouping pyramids and combine into final saliency map
h = ittiNorm(gPyr,8);

%Save Saliency
% imagesc(h.data);colorbar;axis image
% [~,name,~]=fileparts(filename)
% saveas(gcf,['Result_',name,'.png'])
% saveas(gcf,['Result_',name,'.fig'])
% save(['Result_',name,'.mat'],'h');
toc
fprintf('\nDone\n')