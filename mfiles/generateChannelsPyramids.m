function imgPyr = generateChannelsPyramids(im,params)
%Generates the data structure to hold the different channels the algorithm
%operates on
%
%Inputs:
%im - input image to algorithm
%params - model parameter structure
%
%outputs:
%img - data structure holding different feature channels

[in, R,G,B,Y] = makeColors(im);

%Generate color opponency channels
rg = R-G;
by = B-Y;
gr = G-R;
yb = Y-B;
%Threshold opponency channels
rg(rg<0) = 0;
gr(gr<0) = 0;
by(by<0) = 0;
yb(yb<0) = 0;

%imagesc(exIm)
for c = 1:length(params.channels)
    if strcmp(params.channels(c),'I')
        %intensity
        fprintf('\nGenerating Intensity Pyramids\n');
        imgPyr{c}.subtype{1}.pyr = makePyramid(in,params);
        %img{c}.subtype{1}.data = in;
        imgPyr{c}.subtype{1}.type = 'Intensity';
        imgPyr{c}.type = 'Intensity';
        
    elseif strcmp(params.channels(c),'C')
        %color
        fprintf('\nGenerating Color Pyramids\n');
        imgPyr{c}.type = 'Color';
        imgPyr{c}.subtype{1}.pyr = makePyramid(rg,params);
        imgPyr{c}.subtype{1}.type = 'Red-Green Opponency';
        
        imgPyr{c}.subtype{2}.pyr = makePyramid(gr,params);
        imgPyr{c}.subtype{2}.type = 'Green-Red Opponency';
        
        imgPyr{c}.subtype{3}.pyr = makePyramid(by,params);
        imgPyr{c}.subtype{3}.type = 'Blue-Yellow Opponency';
        
        imgPyr{c}.subtype{4}.pyr = makePyramid(yb,params);
        imgPyr{c}.subtype{4}.type = 'Yellow-Blue Opponency';
        
    elseif strcmp(params.channels(c),'O')
        %orientation
        fprintf('\nGenerating Orientation Pyramids\n');
        tmpPyr = makePyramid(in,params);
        imgPyr{c}.type = 'OrientationOriginal';
        imgPyr{c}.subtype{1}.ori = 0; %orientation channel angle
        imgPyr{c}.subtype{1}.type = 'Orientation';
        fprintf('%d deg\n',0);
        imgPyr{c}.subtype{1}.pyr = makePyramid(in,params);
        imgPyr{c}.subtype{2}.ori = pi/4;
        imgPyr{c}.subtype{2}.type = 'Orientation';
        fprintf('%d deg\n',rad2deg(pi/4));
        imgPyr{c}.subtype{2}.pyr = makePyramid(in,params);
        imgPyr{c}.subtype{3}.ori = pi/2;
        imgPyr{c}.subtype{3}.type = 'Orientation';
        fprintf('%d deg\n',rad2deg(pi/2));
        imgPyr{c}.subtype{3}.pyr = makePyramid(in,params);
        imgPyr{c}.subtype{4}.ori = 3*pi/4;
        imgPyr{c}.subtype{4}.type = 'Orientation';
        fprintf('%d deg\n',rad2deg(3*pi/4));
        imgPyr{c}.subtype{4}.pyr = makePyramid(in,params);
        
    elseif strcmp(params.channels(c),'R')
        %oRientation opponency
        fprintf('\nGenerating Orientation Opponency Gaussian Pyramids\n');
        tmpPyr = makePyramid(in,params);
        imgPyr{c}.type = 'Orientation-Oppo-Gauss';
        imgPyr{c}.subtype{1}.type = '0-90_Opponency';
        Gabor0 = gaborPyramidRand(tmpPyr,0,params);
        
        imgPyr{c}.subtype{2}.type = '90-0_Opponency';
        Gabor1 = gaborPyramidRand(tmpPyr,pi/4,params);
        
        imgPyr{c}.subtype{3}.type = '45-135_Opponency';
        Gabor2 = gaborPyramidRand(tmpPyr,pi/2,params);
        
        imgPyr{c}.subtype{4}.type = '135-45_Opponency';
        Gabor3 = gaborPyramidRand(tmpPyr,3*pi/4,params);
        
        for ii=1:length(Gabor0)
            Gabor0(ii).data=abs(Gabor0(ii).data);
            Gabor1(ii).data=abs(Gabor1(ii).data);
            Gabor2(ii).data=abs(Gabor2(ii).data);
            Gabor3(ii).data=abs(Gabor3(ii).data);
            Gabor0_2(ii).data=Gabor0(ii).data-Gabor2(ii).data;
            Gabor2_0(ii).data=Gabor2(ii).data-Gabor0(ii).data;
            Gabor1_3(ii).data=Gabor1(ii).data-Gabor3(ii).data;
            Gabor3_1(ii).data=Gabor3(ii).data-Gabor1(ii).data;
            Gabor0_2(ii).msk=Gabor0(ii).msk;
            Gabor2_0(ii).msk=Gabor2(ii).msk;
            Gabor1_3(ii).msk=Gabor1(ii).msk;
            Gabor3_1(ii).msk=Gabor3(ii).msk;            
            Gabor0_2(ii).data(Gabor0_2(ii).data<0)=0;
            Gabor2_0(ii).data(Gabor2_0(ii).data<0)=0;
            Gabor1_3(ii).data(Gabor1_3(ii).data<0)=0;
            Gabor3_1(ii).data(Gabor3_1(ii).data<0)=0;
        end
        imgPyr{c}.subtype{1}.pyr = Gabor0_2;
        imgPyr{c}.subtype{2}.pyr = Gabor2_0;
        imgPyr{c}.subtype{3}.pyr = Gabor1_3;
        imgPyr{c}.subtype{4}.pyr = Gabor3_1;
        imgPyr{c}.subtype{1}.ori = 0; %orientation channel angle
        imgPyr{c}.subtype{2}.ori = pi/2;
        imgPyr{c}.subtype{3}.ori = pi/4;
        imgPyr{c}.subtype{4}.ori = 3*pi/4;
        
        for ii=1:4 %Gaussian Filter
            for jj=1:length(imgPyr{c}.subtype{1}.pyr)
                imgPyr{c}.subtype{ii}.pyr(jj).data = imgaussfilt(abs(imgPyr{c}.subtype{ii}.pyr(jj).data),params.OrientationOppoGauss,'Padding','symmetric');
            end
        end
    end
end