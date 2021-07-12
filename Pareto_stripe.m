% Code that constructs the Pareto stripe

for iterate_WC_limit = 0:WC_limit_grid_density
    
    WC_limit = Objectives_worst_case(iterate_instance,1) + iterate_WC_limit*(SP_Objectives_worst_case(iterate_instance) - Objectives_worst_case(iterate_instance,1))/WC_limit_grid_density;
    
    SP_solver;
    
    Pareto_stripe_upper_bound(iterate_WC_limit+1,iterate_instance) = cvx_optval;
    
    Best_case_evaluation_for_Pareto_stripe; 
    
end