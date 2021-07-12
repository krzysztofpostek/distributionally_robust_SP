
Ordering_LDR_test = reshape(double(full(Ordering_LDR))',[T+1 1 T]);
ORDERING_DECISIONS = reshape(sum(repmat(Ordering_LDR_test,[1 3^T]).*repmat(Demands_scenarios_mu_d,[1 1 T]),1),[3^T T])';
performance_optval = sum(Demand_probabilities_mu_d.*(c'*ORDERING_DECISIONS + sum((repmat(Coefficients_holding,[1 3^T]).*max(x_1+cumsum(ORDERING_DECISIONS - Demands_scenarios_mu_d(2:T+1,:),1),0) + repmat(Coefficients_backlogging,[1 3^T]).*max((-x_1-cumsum(ORDERING_DECISIONS - Demands_scenarios_mu_d(2:T+1,:),1)),0)),1))) ;
