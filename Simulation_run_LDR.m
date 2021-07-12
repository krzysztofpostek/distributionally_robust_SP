    


for iterate_simulate = 1:N_sim
    
        Realized_demand = sampled_demands_uniform(:,iterate_simulate);
        Orders = Ordering_LDR*Realized_demand;
        Results_simulation_uniform(iterate_instance,beta_iterate,iterate_simulate) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_uniform(2:T+1,iterate_simulate)),0));
        
        Realized_demand = sampled_demands_mu_d(:,iterate_simulate);
        Orders = Ordering_LDR*Realized_demand;
        Results_simulation_mu_d(iterate_instance,beta_iterate,iterate_simulate) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate))),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - sampled_demands_mu_d(2:T+1,iterate_simulate)),0));

end