
    % In order to run this file you need to open the file Big_data_inventory,
    % which has been constructed for T=6 time periods

    rho = 0.25;
    T = 6;
    N_bins_histogram = 36;

    % Setting the one-sided probabilities
    
    N_instances = 50;
    %SP_Objectives_worst_case = zeros(N_instances,1);
    %SP_Objectives_worst_case_mu_d = zeros(N_instances,1);
    %SP_Objectives_best_case = zeros(N_instances,3)
    %Convexity_of_decisions = zeros(T,3);
    Angles = zeros(T,N_bins_histogram+1);
    
    %Objectives_worst_case_mu = zeros(N_instances,1);
    %Objectives_best_case_together = zeros(N_instances,15,length(beta_range));

    N_sim = 10^4;
    %SP_Results_simulation_uniform = zeros(N_sim,1,N_instances);
    %SP_Results_simulation_mu_d = zeros(N_sim,1,N_instances);
    %SP_Results_simulation_mu = zeros(N_sim,1,N_instances);
    %SP_Times = zeros(N_instances,1);

    for iterate_instance = 1:N_instances
        
        tic
        
        Data_setting_mu_d;

        sampled_demands_uniform = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_scenarios_01_uniform;
        sampled_demands_mu_d = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_01_mu_d;
        sampled_demands_mu = repmat(lb,[1 N_sim]) + repmat(ub-lb,[1 N_sim]).*sampled_01_mu;

        %%%% Solve the adjustable SP problem
        cvx_clear;
        position_table = 1;
        %WC_limit = Objectives_worst_case(iterate_instance,13);
        SP_solver;
        
        %Convexity_check;
        %Convexity_of_decisions = Convexity_of_decisions + Convexity_of_decisions_instance;
        
        Angle_check;
        Angles = Angles + Angles_instance;
        
        SP_Objectives_worst_case_mu_d(iterate_instance,position_table) = cvx_optval;
        SP_Objectives_worst_case(iterate_instance,position_table) = max((c'*q + sum(repmat(Demand_coefficients_holding,[1 3^T]).*max((x_1+cumsum(q-Demands_scenarios_mu_d(2:T+1,:))),0) + repmat(Demand_coefficients_backlogging,[1 3^T] ).*max((-x_1-cumsum(q-Demands_scenarios_mu_d(2:T+1,:))),0))));
        
        Best_case_evaluation; 
        
        %Simulation_run;
        
        if(not(logical(mod(iterate_instance,5))))
            save(strcat(['Results_combined.mat']));
        end

        SP_Times(iterate_instance) = toc;
        
    end
