% File solving the adjustable mu d
cvx_begin
    variable Ordering_LDR_mu_d_shape(T+1,1,T);
    variable Ordering_LDR(T,T+1);
    variable objective_function;
    variable ORDERING_DECISIONS_mu_d(T,3^T);
    variable ORDERING_DECISIONS_mu_d_beta(T,2^T);
    minimize(objective_function);
    
    subject to
        ORDERING_DECISIONS_mu_d == reshape(sum(repmat(Ordering_LDR_mu_d_shape,[1 3^T]).*repmat(Demands_scenarios_mu_d,[1 1 T]),1),[3^T T])';
        ORDERING_DECISIONS_mu_d_beta == reshape(sum(repmat(Ordering_LDR_mu_d_shape,[1 2^T]).*repmat(Demands_scenarios_best_case,[1 1 T]),1),[2^T T])';
        
        sum(Demand_probabilities_best_case.*(c'*ORDERING_DECISIONS_mu_d_beta + sum((repmat(Coefficients_holding,[1 2^T]).*max(x_1+cumsum(ORDERING_DECISIONS_mu_d_beta - Demands_scenarios_best_case(2:T+1,:),1),0) + repmat(Coefficients_backlogging,[1 2^T]).*max((-x_1-cumsum(ORDERING_DECISIONS_mu_d_beta - Demands_scenarios_best_case(2:T+1,:),1)),0)),1))) <= objective_function;
        
        max(c'*ORDERING_DECISIONS_mu_d + sum((repmat(Coefficients_holding,[1 3^T]).*max(x_1+cumsum(ORDERING_DECISIONS_mu_d - Demands_scenarios_mu_d(2:T+1,:),1),0) + repmat(Coefficients_backlogging,[1 3^T]).*max((-x_1-cumsum(ORDERING_DECISIONS_mu_d - Demands_scenarios_mu_d(2:T+1,:),1)),0)),1)) <= WC_limit;

        
        ORDERING_DECISIONS_mu_d <= repmat(U,[1 3^T]);    
        ORDERING_DECISIONS_mu_d >= repmat(L,[1 3^T]);   
        
        cumsum(ORDERING_DECISIONS_mu_d,1) <= repmat(U_cum,[1 3^T]);    
        cumsum(ORDERING_DECISIONS_mu_d,1) >= repmat(L_cum,[1 3^T]);
        
        for t=1:T
            Ordering_LDR_mu_d_shape(t+1:T+1,1,t) == zeros(T+1-t,1);
        end
        
        Ordering_LDR_mu_d_shape == reshape(Ordering_LDR',[T+1 1 T]);
        
cvx_end