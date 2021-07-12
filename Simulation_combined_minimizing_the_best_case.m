
% In order to run this file you need to open the file Big_data_inventory,
% which has been constructed for T=6 time periods

    beta_range = [0.25 0.5 0.75];
    rho = 0.25;
    T=6;

    % Setting the one-sided probabilities
    N_instances=50;
    
    Objectives_worst_case = zeros(N_instances,length(beta_range));
    Objectives_mu_d = zeros(N_instances,length(beta_range));
    Objectives_mu_d_beta = zeros(N_instances,length(beta_range),length(beta_range));

    N_sim=10^4;
    Results_simulation_uniform = zeros(N_instances,length(beta_range),N_sim);
    Results_simulation_mu_d = zeros(N_instances,length(beta_range),N_sim);
    Times = zeros(N_instances,1);

    for iterate_instance = 1:N_instances
        
        tic
        Data_setting_mu_d;

        sampled_demands_uniform = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_scenarios_01_uniform;
        sampled_demands_mu_d = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_01_mu_d;

        for beta_iterate = 1:3  
    
            beta_best_case = beta_range(beta_iterate);
            beta_vector = beta_best_case*ones(T,1);
            Data_setting_best_case;
            
            Adjustable_mu_d_beta;
            
            Objectives_mu_d_beta(iterate_instance,beta_iterate) = cvx_optval;
            Objectives_worst_case(iterate_instance,beta_iterate) = max((c'*ORDERING_DECISIONS_mu_d + sum((repmat(Coefficients_holding,[1 3^T]).*max(x_1+cumsum(ORDERING_DECISIONS_mu_d - Demands_scenarios_mu_d(2:T+1,:),1),0) + repmat(Coefficients_backlogging,[1 3^T]).*max((-x_1-cumsum(ORDERING_DECISIONS_mu_d - Demands_scenarios_mu_d(2:T+1,:),1)),0)),1)));

            Performance_in_mu_d_setting;
            Objectives_mu_d(iterate_instance, beta_iterate) = performance_optval;
            
            Simulation_run_LDR;

        end
        
        if(not(logical(mod(iterate_instance,5))))
            save(strcat(['Results_combined(minimizing worst_case).mat']));
        end

        Times(iterate_instance) = toc;
    end
