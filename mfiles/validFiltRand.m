 function newMap = validFiltRand(map,msk)
%performs a valid correlation/convolution of map and msk. The result is
%zero padded to the same size as map once the filtering as been performed

[mapYsize, mapXsize]=size(map);
[mskYsize, mskXsize]=size(msk);
exXsize=ceil(mskXsize/2);
exYsize=ceil(mskYsize/2);
if exXsize>mapXsize/3
    exXsize=floor(mapXsize/3);
end
if exYsize>mapYsize/3
    exYsize=floor(mapYsize/3);
end
exMap=zeros(mapYsize+2*exYsize,mapXsize+2*exXsize);
[largeYsize,largeXsize]=size(exMap);
for yy=1:exYsize*2 %Top Left
    for xx=1:exXsize*2
        maxV=max(max(map(1:yy+exYsize-1,1:xx+exXsize-1)));
        minV=min(min(map(1:yy+exYsize-1,1:xx+exXsize-1)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end

for yy=1:exYsize*2 %Top Right
    for xx=largeXsize-(exXsize*2)+1:largeXsize
        maxV=max(max(map(1:yy+exYsize-1,xx-3*exXsize+1:mapXsize)));
        minV=min(min(map(1:yy+exYsize-1,xx-3*exXsize+1:mapXsize)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end

for yy=largeYsize-(exYsize*2)+1:largeYsize %Bottom Left
    for xx=1:exXsize*2
        maxV=max(max(map(yy-3*exYsize+1:mapYsize,1:xx+exXsize-1)));
        minV=min(min(map(yy-3*exYsize+1:mapYsize,1:xx+exXsize-1)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end

for yy=largeYsize-(exYsize*2)+1:largeYsize %Bottom Right
    for xx=largeXsize-(exXsize*2)+1:largeXsize
        maxV=max(max(map(yy-3*exYsize+1:mapYsize,xx-3*exXsize+1:mapXsize)));
        minV=min(min(map(yy-3*exYsize+1:mapYsize,xx-3*exXsize+1:mapXsize)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end

for yy=1:exYsize %Top Side
    for xx=exXsize*2+1:largeXsize-(exXsize*2)
        maxV=max(max(map(1:yy+exYsize-1,xx-2*exXsize:xx)));
        minV=min(min(map(1:yy+exYsize-1,xx-2*exXsize:xx)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end
    
for yy=largeYsize-exYsize+1:largeYsize %Bottom Side
    for xx=exXsize*2+1:largeXsize-(exXsize*2)
        maxV=max(max(map(yy-3*exYsize+1:mapYsize,xx-2*exXsize:xx)));
        minV=min(min(map(yy-3*exYsize+1:mapYsize,xx-2*exXsize:xx)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end
    
for yy=exYsize*2+1:largeYsize-(exYsize*2) %Left Side
    for xx=1:exXsize
        maxV=max(max(map(yy-2*exYsize:yy,1:xx+exXsize-1)));
        minV=min(min(map(yy-2*exYsize:yy,1:xx+exXsize-1)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end

for yy=exYsize*2+1:largeYsize-(exYsize*2) %Right Side
    for xx=largeXsize-exXsize+1:largeXsize
        maxV=max(max(map(yy-2*exYsize:yy,xx-3*exXsize+1:mapXsize)));
        minV=min(min(map(yy-2*exYsize:yy,xx-3*exXsize+1:mapXsize)));
        exMap(yy,xx)=(maxV-minV)*rand()+minV;
    end
end


exMap(1+exYsize:exYsize+mapYsize,1+exXsize:exXsize+mapXsize)=map;
tmpMap = imfilter(exMap,msk,'symmetric');
newMap=tmpMap(1+exYsize:exYsize+mapYsize,1+exXsize:exXsize+mapXsize);