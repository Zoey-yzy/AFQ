function AFQ_PlotResults(patient_data, norms, abn, cutoff,property, numberOfNodes, outdir, savefigs);
% This function will plot all the results of the previous analyses

fgNames={'Left Thalmic Radiation','Right Thalmic Radiation','Left Corticospinal','Right Corticospinal', 'Left Cingulum Cingulate', 'Right Cingulum Cingulate'...
    'Left Cingulum Hippocampus','Right Cingulum Hippocampus', 'Callosum Forceps Major', 'Callosum Forceps Minor'...
    'Left IFOF','Right IFOF','Left ILF','Right ILF','Left SLF','Right SLF','Left Uncinate','Right Uncinate','Left Arcuate','Right Arcuate'};
%% calc and plot
cutZ=norminv(cutoff*.01);
cutZ2=norminv([.25 .75]);
% norminv()是标准累积分布函数（cdf）的逆，但这里的自变量是啥？是纤维到纤维束中心的距离吗？
% x = norminv(p)
% x = norminv(p,mu)
% x = norminv(p,mu,sigma)
%first collect value of interet
for jj=1:length(fgNames)
    figure(jj);hold on;
    % 25 and 75 percentile bands
    x=[1:numberOfNodes fliplr(1:numberOfNodes)];
    y=vertcat(norms.meanFA(:,jj)+max(cutZ)*norms.sdFA(:,jj), flipud(norms.meanFA(:,jj)+min(cutZ)*norms.sdFA(:,jj)));
    fill(x,y, [.6 .6 .6]);
    % is 'cutoff' a value or a range? probably a range as its 'max' and 'min' exist in the syntax
    % vertcat() is used to concatemate the 2 matrixes vertically
    clear y
    y=vertcat(norms.meanFA(:,jj)+max(cutZ2)*norms.sdFA(:,jj), flipud(norms.meanFA(:,jj)+min(cutZ2)*norms.sdFA(:,jj)));
    fill(x,y, [.3 .3 .3]);
    clear y
    %% cutZ和cutZ2有什么区别？cutoff是什么？这一部分是计算每个node的FA值（含标准差）
    %% x和y为什么需要把向量顺序倒置后相加？
    plot(norms.meanFA(:,jj),'-','Color','k','LineWidth',5);
    axis([1 numberOfNodes .2 .9]);
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Fractional Anisotropy','fontName','Times','fontSize',14)
    title(fgNames{jj},'fontName','Times','fontSize',14)
    set(gcf,'Color','w');
    set(gca,'Color',[.9 .9 .9],'fontName','Times','fontSize',12)
end
%% add patients to plot
% we will only plot premies who are abnormal on at least 1 tract
c=hsv(sum(abn));
% hsv() is a colormap
c=c./1.4;
c(2:2:end,:)=c(2:2:end,:)./1.5;
for ii=1:size(patient_data(1).FA,1)
    for jj=1:length(patient_data)
        figure(jj);hold on;
        if abn(ii)==1
            switch(property)
                case 'AD'
                    plot(patient_data(jj).AD(ii,:),'color',c(sum(abn(1:ii)),:),'linewidth',2);hold on;
                case 'RD'
                    plot(patient_data(jj).RD(ii,:),'color',c(sum(abn(1:ii)),:),'linewidth',2);hold on;
                case 'FA'
                    plot(patient_data(jj).FA(ii,:),'color',c(sum(abn(1:ii)),:),'linewidth',2);hold on;
            end
        end
    end
end
if savefigs==1
    cd(outdir)
    for ii=1:length(fa)
        figure(ii);
        set(gcf,'Color','w','InvertHardCopy','off','PaperPositionMode','auto');
        saveas(gcf,['Figure' num2str(ii)],'png');
    end
end

