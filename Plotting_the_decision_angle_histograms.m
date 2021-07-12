% Plotting the histograms

figure(2);

for i = 2:6
    
    subplot(5,1,i-1);
    bar(linspace(0,360,N_bins_histogram+1)',Angles(i,:)');
    title(strcat(['Period ' num2str(i)]));
    xlabel('Angle');
    ylabel('Count');
    
end