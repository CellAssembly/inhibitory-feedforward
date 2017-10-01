clc; clear

EneuronNum = 1600;
IneuronNum = round(.25*EneuronNum);
neuronNum = EneuronNum + IneuronNum;
numClusters = 5;

weightFactor = 2.6%1:.2:2.6;
repetitions = 3%10;
MeanCorr = zeros(length(weightFactor), repetitions);
XCorr = cell(length(weightFactor), repetitions);
AllSpikesInh = cell(length(weightFactor), repetitions);
AllSpikesExc = cell(length(weightFactor), repetitions);

xxx = 0;
for yyy = weightFactor
    xxx = xxx + 1
    
    for zzz = 1:repetitions
        zzz
        
        PARAMS.factorEI  = yyy;
        PARAMS.factorIE  = yyy;
        PARAMS.pfactorEI = yyy;
        PARAMS.pfactorIE = yyy;
        
        PARAMS.factorII  = yyy;
        PARAMS.pfactorII = yyy;
        
        PARAMS.wEI = 0.042;  %.015
        PARAMS.pEI = .5;
        
        PARAMS.wIE = 0.0105;  %.015
        PARAMS.pIE = .5;
        
        PARAMS.wEE     = 0.022;  %.015
        PARAMS.pEE     = .2;
        
        PARAMS.wII     = 0.042;  %.057
        PARAMS.pII     = .5;
        
        % get weight matrix
        [weightsEE, weightsEI, weightsIE, weightsII] = create_EIIE_topology(EneuronNum,numClusters,PARAMS);
        %simluate raster
        rast = simulate_LIF_network(weightsEE,weightsEI,weightsIE,weightsII,5000);
        
        % convert and plot
        conversion_spike_data
        partition= [kron(1:numClusters,ones(1,EneuronNum/numClusters)), ...
            kron(1:numClusters,ones(1,IneuronNum/numClusters))];
        % plotRaster_with_ordering(spksExc,spksInh,neuronNum,partition)
        
        
        gaussian_width = 50; % 10 corresponds to 1ms
        TimeSignals = conv_spike_trains(rast, gaussian_width);
        %------------------------------------------
        % first part -- get correlation coefficients
        % the more synchronous the more they should go up
        R = corrcoef(TimeSignals');
        R(isnan(R)) = 0;
        
        % average correlation coefficient over groups
        % TODO comparison over all nodes as "null model"?
        PartIndMatrix = transformPartitionVectorToHMatrix(partition);
        MaskOutEntries = PartIndMatrix*PartIndMatrix';
        MaskOutEntries = MaskOutEntries -  eye(size(MaskOutEntries));
        mean_corr= mean(R(logical(MaskOutEntries)));
        
        MeanCorr(xxx,zzz) = mean_corr;
        %---------------------------------------------
        % get autocovariance for "lag" between groups
        % and possibly repetition frequency et.
        mean_signals = ((PartIndMatrix'*PartIndMatrix)\PartIndMatrix')*TimeSignals;
        % alt:use crosscorr / autocorr; but: slower..
        [xcorrelation, lags] = xcov(mean_signals',1000,'none');
        % average over all the corresponding pairs of groups (no shift,+1,+2)
        XCorr_ =  zeros(5,length(xcorrelation));
        for i=1:numClusters
            indices = find(circshift(eye(5),i));
            XCorr_(i,:) = mean(xcorrelation(:,indices),2);
        end
        XCorr{xxx,zzz} = XCorr_;
        AllSpikesExc{xxx,zzz} = spksExc;
        AllSpikesInh{xxx,zzz} = spksInh;
        clear TimeSignals;
    end
    save('ParameterSweepEIIE_5seconds')
    
end

