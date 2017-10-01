function plotRaster_with_ordering(spksExc,spksInh,neuronNum,partition)
    % sort ordering twice to get node order according to partition indicated
    % sort once to get names of nodes in order of partition
    [~,ii] = sort(partition);
    % sort twice to get remapping of nodes..
    [~,ii] = sort(ii);

    figure;
    set(gcf,'Color',[1 1 1])
    plot(spksExc(:,2),ii(spksExc(:,1)),'r.','MarkerSize',0.5);
    hold on; 
    if exist('spksInh','var')
        plot(spksInh(:,2),ii(spksInh(:,1)),'b.','MarkerSize',0.5); 
    end
    if exist('tEnd','var')
        axis([0 tEnd/1000 1 neuronNum])   %convert to seconds
    else 
        tEnd = max(spksInh(:,2))*1000;
        axis([0 tEnd/1000 1 neuronNum])
    end
%     xlabel('Time / sec'); ylabel('Neuron Number')
%     set(gca,'FontSize',30)

end
