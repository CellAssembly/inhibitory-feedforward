% script to convert full data to Humphries spike format
% Total number of spikes from all neurons in the simulation time
totalNumSpks = find (rast > 0);  
% Two colunm matrix called spks to agree with Humphries code, 
% first colunm is neuron ID, second colunm is time stamp of the spike  that neuron
spksAll = zeros(length(totalNumSpks),2); 
% Will be used in for loop to make sure not override any cells or skip any 
% cells in the spks matrix
spikeCountTracker = 0;    
tStep = 0.1;                       

for i = 1:neuronNum
    spikesNeuron = find (rast(i,:) > 0);
    numSpikesNeuron = length(spikesNeuron);
    
    if (numSpikesNeuron > 0)
        %to convert to seconds
        spksAll(spikeCountTracker+1:spikeCountTracker+numSpikesNeuron,2) = spikesNeuron'*tStep*(10^-3);    
        spksAll(spikeCountTracker+1:spikeCountTracker+numSpikesNeuron,1) = i*ones(numSpikesNeuron,1);
    end
    
    spikeCountTracker = spikeCountTracker + numSpikesNeuron;
end

length(totalNumSpks);
spikeCountTracker;

firstInhNeuron = find(spksAll(:,1) > EneuronNum);

spksExc = spksAll(1:firstInhNeuron(1) - 1,:);
spksInh = spksAll(firstInhNeuron(1):length(spksAll),:);
