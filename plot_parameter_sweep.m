clear; clc; close all;
load('ParameterSweepEIIE_5seconds.mat');

% transform lag time-stamps into milliseconds
tt = lags*.1;

%%
% Figure 1 -- average CC with increasing parameter
figure; errorbar(weightFactor,mean(MeanCorr,2),std(MeanCorr,0,2),'k');
ax = gca; 
ax.FontName = 'Arial';
ax.FontSize = 8;
xlim([1,2.65]);
ax.XTickMode = 'Manual';
ax.XTick = [1 1.4 1.8 2.2 2.6];
ax.YTickMode = 'Manual';
ax.YTick = [0 .05 .1 .15 .2];
ax.YTickLabel = {'0','','0.1','','0.2'};
box off;
ax.LineWidth = 0.5;
% xlabel('Parameter Ratio Q')
% ylabel('Corr. coefficient \rho')
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 4 3];
fig.PaperPositionMode = 'Manual';
print('figure_EI_CCvsParam','-depsc2')


%%
% assemble average autocovariance curves
XCorr0=0;
XCorr1=0;
max_i = length(weightFactor);
for i=1:repetitions
    XCorr0 = XCorr{1,i}+XCorr0;
    XCorr1 = XCorr{max_i,i}+XCorr1;
end
XCorr0 = XCorr0/repetitions;
XCorr1 = XCorr1/repetitions;


% Figure 2 -- plot crosscovariance averaged over own group for min and max parameter setting
figure
plot(tt,XCorr0(5,:)','k-')
hold all
plot(tt,XCorr1(5,:)','b-')
% legend('Q=0', 'Q=1','Location','Best')
ylim([-0.004, 0.02])
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 4 3];
fig.PaperPositionMode = 'Manual';
ax = gca; 
ax.FontName = 'Arial';
ax.FontSize = 8;
ax.XTickMode = 'Manual';
ax.XTick = [-90 -45 0 45 90];
box off;
ax.LineWidth = 0.5;
% xlabel('Parameter Ratio Q')
% ylabel('Corr. coefficient \rho')
print('figure_EI_minVsMax','-depsc2')

% Figure 3 -- plot crosscovariance with respect to all other groups, for maximal parameter setting
figure
plot(tt,XCorr1(5,:)')
hold all
plot(tt,XCorr1(4,:)')
plot(tt,XCorr1(3,:)')
plot(tt,XCorr1(2,:)')
plot(tt,XCorr1(1,:)')
% legend('Layer i', 'Layer i+1','Layer i+2', 'Layer i+3','Layer i+4')
ylim([-0.004, 0.02])
ax = gca; 
ax.FontName = 'Arial';
ax.FontSize = 8;
ax.XTickMode = 'Manual';
ax.XTick = [-90 -45 0 45 90];
box off;
ax.LineWidth = 0.5;
% xlabel('Parameter Ratio Q')
% ylabel('Corr. coefficient \rho')
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 4 3];
fig.PaperPositionMode = 'Manual';
print('figure_EI_CCgroups','-depsc2')

%% 
% Plot Example Rasters
plotRaster_with_ordering(spksExc,spksInh,neuronNum,partition);
ax = gca; 
ax.FontName = 'Arial';
ax.FontSize = 8;
xlim([0,0.5]);
ax.XTickMode = 'Manual';
ax.XTick = [0 0.1 0.2 0.3 0.4];
box off;
ax.LineWidth = 0.5;
% xlabel('Parameter Ratio Q')
% ylabel('Corr. coefficient \rho')
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 4 3];
fig.PaperPositionMode = 'Manual';
print('raster_EI_final','-depsc2')

%inset random
spksExc = AllSpikesExc{1,7};
spksInh = AllSpikesInh{1,7};
plotRaster_with_ordering(spksExc,spksInh,neuronNum,partition);
ax = gca; 
ax.FontName = 'Arial';
ax.FontSize = 8;
xlim([0,0.5]);
ax.XTickMode = 'Manual';
ax.XTick = [0 0.1 0.2 0.3 0.4];
ax.LineWidth = 0.5;
% xlabel('Parameter Ratio Q')
% ylabel('Corr. coefficient \rho')
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 4 3];
fig.PaperPositionMode = 'Manual';
print('raster_EI_inset','-depsc2')

%%
%Plot delta as a function of Q

delta = zeros(10,9);
group = 1;

for i =1:9          %Values of Q iterated over
    for j = 1:10    %Number of iterations
        temp = XCorr{i,j}(group,:);
        sel = (max(temp)-min(temp))/4;
        peaks = peakfinder(temp, sel, 0.5*max(temp));
        if length(peaks) > 1
            delta(j,i) = (peaks(end) - peaks(end - 1)) * 0.1;
        else
            delta(j,i) = NaN;
        end
    end
end

figure()
plot(weightFactor, delta, 'b','LineWidth',0.25)
hold on
errorbar(weightFactor,mean(delta),std(delta),'k');
xlabel('Q')
ylabel('\delta (ms)')


ax = gca; 
ax.FontName = 'Arial';
ax.FontSize = 10;
ax.LineWidth = 1;
box off
% xlabel('Parameter Ratio Q')
% ylabel('Corr. coefficient \rho')
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 5.5 4.2];
fig.PaperPositionMode = 'Manual';
print('DeltaVsQ_EI','-depsc2')


% To see an individual example
% for i = 1:4:9
%     figure(i+100); plot(XCorr{i,1}(1,:))
% end

