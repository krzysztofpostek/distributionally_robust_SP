% Plotting the Pareto stripe aggregated

subplot(1,2,2)
hold on

x_coors = mean(repmat(Objectives_worst_case(:,1),[1 WC_limit_grid_density+1]) + repmat([0:WC_limit_grid_density],[N_instances 1]).*repmat(SP_Objectives_worst_case - Objectives_worst_case(:,1),[1 WC_limit_grid_density+1])/WC_limit_grid_density,1)';

plot(x_coors, mean(Pareto_stripe_final_upper_bound(:,:),2),'k',x_coors, mean(Pareto_stripe_final_lower_bound(:,:,1),2),'--k',x_coors, mean(Pareto_stripe_final_lower_bound(:,:,2),2),':k',x_coors, mean(Pareto_stripe_final_lower_bound(:,:,3),2),'.-k');

grid on;
hold off
% 
ylabel('Expectation (mean across instances)');
xlabel('Worst-case performance (mean across instances)');
legend('WCE','BCE-0.25','BCE-0.5','BCE-0.75');