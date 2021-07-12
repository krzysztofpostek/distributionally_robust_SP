% SP solver

% Matrix for setting up the equality constraints between vectors 

Scenario_matrix_1_2_3 = [];

for t = 1:T
    
    Scenario_matrix_1_2_3 = [kron(Scenario_matrix_1_2_3,ones(1,3)) ; repmat([1 2 3],[1 3^(t-1)]) ];
    
end

% This file solves the fully adjustable version of the problem

% Allocating the matrices with coefficients for the maximum terms.
Demand_coefficients_holding = h - ([1:T]' == T)*s;
Demand_coefficients_backlogging = p;

Equality_constraints_binary = ones(3^T-1,1);

% Now we establish the equality constraints between various decision
% vectors, based on their corresponding scenarios

for iterate_scenario=0:3^T-1
    
    if(iterate_scenario>0)
        for i=1:T-1
            % Condition that if the first i outcomes of a scenario are the
            % same, then the corresponding decision vectors should be the
            % same up to time i+1
            if(prod(double(Scenario_matrix_1_2_3(1:i,iterate_scenario)==Scenario_matrix_1_2_3(1:i,iterate_scenario+1))) > 0)
                Equality_constraints_binary(iterate_scenario) = i+1;
            end
        end
    end
    
end

% Defining the optimization file
cvx_begin
    % Ordering variables
    variable q(T,3^T) nonnegative
    % Objective proxy variables
    variable objective_proxy
    
    minimize(objective_proxy)
    subject to
    
        % The objective constraints
        sum((c'*q + sum(repmat(Demand_coefficients_holding,[1 3^T]).*max((x_1+cumsum(q-Demands_scenarios_mu_d(2:T+1,:))),0) + repmat(Demand_coefficients_backlogging,[1 3^T] ).*max((-x_1-cumsum(q-Demands_scenarios_mu_d(2:T+1,:))),0))).*Demand_probabilities_mu_d) <= objective_proxy;
        %max((c'*q + sum(repmat(Demand_coefficients_holding,[1 3^T]).*max((x_1+cumsum(q-Demands_scenarios_mu_d(2:T+1,:))),0) + repmat(Demand_coefficients_backlogging,[1 3^T] ).*max((-x_1-cumsum(q-Demands_scenarios_mu_d(2:T+1,:))),0)))) <= WC_limit;
        
        % The purchase size constraints
        q <= repmat(U,[1 3^T]);
        q >= repmat(L,[1 3^T]);
        
        % The cumulative purchase constraints
        cumsum(q) <= repmat(U_cum,[1 3^T]);
        cumsum(q) >= repmat(L_cum,[1 3^T]);
        
        % Equality constraints between decision vectors
        for iterate_scenario=0:3^T-2
            q(1:Equality_constraints_binary(iterate_scenario+1),iterate_scenario+1) == q(1:Equality_constraints_binary(iterate_scenario+1),iterate_scenario+2);
        end
        
cvx_end
