% Plotting the Pareto stripe

hold on

x_coors = Objectives_worst_case(iterate_instance,1) + [0:WC_limit_grid_density]'*(SP_Objectives_worst_case(iterate_instance) - Objectives_worst_case(iterate_instance,1))/WC_limit_grid_density;
plot(x_coors ,Pareto_stripe_final_upper_bound(:,iterate_instance),x_coors, Pareto_stripe_final_lower_bound(:,iterate_instance,1),x_coors,Pareto_stripe_final_lower_bound(:,iterate_instance,2),x_coors,Pareto_stripe_final_lower_bound(:,iterate_instance,3),'LineWidth',0.5);

legend('WCE','BCE-0.25','BCE-0.5','BCE-0.75');

hold off
% 
ylabel('Expectation');
xlabel('Worst-case performance');
title(strcat(['Instance ' num2str(iterate_instance) ]));