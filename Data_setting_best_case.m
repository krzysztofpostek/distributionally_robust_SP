% Setting the means of the demand distribution
mus=(lb+ub)/2;

% Setting the parameter of mean absolute deviation 

% Setting the worst_case probabilities
Probabilities_matrix_best_case = zeros(T,2);

Probabilities_matrix_best_case(:,1) = 1 - beta_vector;
Probabilities_matrix_best_case(:,2) = beta_vector;

% Setting the demand scenarios
Scenarios_best_case = [mus(2:T+1)-0.5*rho*(ub(2:T+1) - lb(2:T+1))./(1-beta_vector) mus(2:T+1)+0.5*rho*(ub(2:T+1) - lb(2:T+1))./beta_vector];

Demands_scenarios_best_case = zeros(T+1,2^T);
Demand_probabilities_best_case = zeros(1,2^T);

% Filling the preallocated matrices
for iterate_scenario=0:2^T-1
    
    % Manipulations to get the coordinates
    vec=dec2base(iterate_scenario,2);
    vec=strcat(repmat('0',[1,T-length(vec)]),vec);
    Positions=[[1:T]'  abs(vec)'-47];
    Positions=mat2cell(Positions, size(Positions, 1), ones(1, size(Positions, 2)));
    
    % Setting the w-c demand scenario and its probability
    Demands_scenarios_best_case(:,iterate_scenario+1) = [1; Scenarios_best_case(sub2ind(size(Scenarios_best_case), Positions{:}))];
    Demand_probabilities_best_case(iterate_scenario+1) = prod(Probabilities_matrix_best_case(sub2ind(size(Probabilities_matrix_best_case), Positions{:})));

end