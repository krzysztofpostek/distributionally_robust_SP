%Data setting file 
lb =lb_matrix(:,iterate_instance);
ub =ub_matrix(:,iterate_instance);
% Lower and upper bounds on the orders
L = L_matrix(:,iterate_instance);
U = U_matrix(:,iterate_instance);
% Lower and upper bounds on cumulative orders
L_cum=L_cum_matrix(1)*ones(T,1);
U_cum=U_cum_matrix(iterate_instance)*ones(T,1);
% Initial inventory state
x_1=x_1_matrix(iterate_instance);
% Ordering costs
c=c_matrix(:,iterate_instance);
% Holding costs
h=h_matrix(:,iterate_instance);
% Backlogging
p=p_matrix(:,iterate_instance);
% Replenishment value
s=0;

% Setting the means of the demand distribution
mus=(lb+ub)/2;

% Setting the parameter of mean absolute deviation 

% Setting the worst_case probabilities
Probabilities_matrix_mu_d=zeros(T,3);

Probabilities_matrix_mu_d(:,1)= 0.5*rho*(ub(2:T+1) - lb(2:T+1))./(mus(2:T+1) - lb(2:T+1));
Probabilities_matrix_mu_d(:,3)= 0.5*rho*(ub(2:T+1) - lb(2:T+1))./(-mus(2:T+1) + ub(2:T+1));
Probabilities_matrix_mu_d(:,2)= ones(T,1) - Probabilities_matrix_mu_d(:,1) - Probabilities_matrix_mu_d(:,3);

% Setting the demand scenarios
Scenarios_mu_d = [lb(2:T+1) mus(2:T+1) ub(2:T+1)];

Demands_scenarios_mu_d = zeros(T+1,3^T);
Demand_probabilities_mu_d = zeros(1,3^T);

% Filling the preallocated matrices
for iterate_scenario=0:3^T-1
    % Manipulations to get the coordinates
    vec=dec2base(iterate_scenario,3);
    vec=strcat(repmat('0',[1,T-length(vec)]),vec);
    Positions=[[1:T]'  abs(vec)'-47];
    Positions=mat2cell(Positions, size(Positions, 1), ones(1, size(Positions, 2)));
    % Setting the w-c demand scenario and its probability
    Demands_scenarios_mu_d(:,iterate_scenario+1) = [1; Scenarios_mu_d(sub2ind(size(Scenarios_mu_d), Positions{:}))];
    Demand_probabilities_mu_d(iterate_scenario+1) = prod(Probabilities_matrix_mu_d(sub2ind(size(Probabilities_matrix_mu_d), Positions{:})));
end

Coefficients_holding = h-([1:T]' == T)*s;
Coefficients_backlogging = p;

A_unc = [eye(T+1) ; -eye(T+1) ] ;
b_unc = [ub ; -lb];
Demand_extraction = [zeros(T,1) eye(T)];