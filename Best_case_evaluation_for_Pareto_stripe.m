
for iterate_beta = 1:length(beta_range)
    
    beta_vector = beta_range(iterate_beta)*ones(T,1);
    Data_setting_best_case;
    Best_case_objective_values = zeros(T,1);
    
    for iterate_best_case_scenario = 1:2^T
        
        Realized_demand = Demands_scenarios_best_case(2:T+1,iterate_best_case_scenario);
        Code_for_tomorrow;
        Best_case_objective_values(iterate_best_case_scenario) = c'*Orders + sum(p.*max((-x_1 -cumsum(Orders - Realized_demand)),0) + (h - ([1:T]' == T)*s).*max(x_1 + cumsum(Orders - Realized_demand),0));

    end
    
    Pareto_stripe_lower_bound(iterate_WC_limit+1,iterate_beta,iterate_instance) = Demand_probabilities_best_case*Best_case_objective_values;
    
end
