% Fleckmentation: hierarchical segmentation using 2-means clustering.
% From 'Fleckmentation: Rapid Segmentation using Repeated 2-Means'
% https://digital-library.theiet.org/content/journals/10.1049/iet-ipr.2018.6060
% DOI:  10.1049/iet-ipr.2018.6060
% https://www.researchgate.net/publication/334393498_Fleckmentation_Rapid_Segmentation_using_Repeated_2-Means
clear;
Irgb        = imread('peppers.png');
[m n nChB]  = size(Irgb);   szI=[m n];    nPix=m*n;

%% -----    Parameters      -----
depth       = 4 ;
maxIter     = 10 ;      % iterations for 2-means
minPixNode  = 10 ;      % min region size for clustering
%% -----    Init for 1st depth  -----
aFprv.PixelIdxList = 1:nPix;    nFprv=1;
%% -----    Init of Maps    -----
ICol        = reshape(single(Irgb),[nPix nChB]);
LMX         = zeros([szI depth]);   % label matrix for plotting

%% SSSSSSSSSSSSSSSSS    LOOP DEPTHS      SSSSSSSSSSSSSSSSSSSSSSSSSS
for d = 1:depth
    % ==========    LOOP PREVIOUS FLECKS    ==========
    aFlk=[];    
    for f = 1:nFprv
        IxReg   = aFprv(f).PixelIdxList;
        if length(IxReg)<minPixNode, continue; end
        LbK     = kmeans(ICol(IxReg,:),2, 'OnlinePhase','off', 'MaxIter',maxIter);
        aIx     = {IxReg(LbK==1); IxReg(LbK==2)};
        % ======   Loop Image Clusters     ========
        for c = 1:2
            BW          = false(szI);   % empty map
            BW(aIx{c})  = true;         % place cluster into map 
            aFlk        = [aFlk; regionprops(BW,'PixelIdxList')];
        end
    end
    aFprv   = aFlk;
    nFprv   = length(aFprv);
    fprintf('depth %d  #flecks %d\n', d, nFprv);
    % ---   Label Matrix For Plotting
    Lm  = zeros(szI);
    for f = 1:nFprv
        Ix      = aFlk(f).PixelIdxList;
        Lm(Ix)  = f;
    end
    LMX(:,:,d) = Lm;
end

%% ---------    Plot    --------
figure(1); colormap('default');
for d = 1:depth
    subplot(2,2,d);
    imagesc(LMX(:,:,d));
end
