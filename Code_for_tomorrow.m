

numbers = repmat([1 2],[T 1]) + repmat( Realized_demand >= Scenarios_mu_d(:,2),[1 2]);

Positions_l = [[1:T]'  numbers(:,1)];
Positions_l = mat2cell(Positions_l, size(Positions_l, 1), ones(1, size(Positions_l, 2)));

Positions_r = [[1:T]'  numbers(:,2)];
Positions_r = mat2cell(Positions_r, size(Positions_r, 1), ones(1, size(Positions_r, 2)));
    
proportions = zeros(T,2);
proportions(:,2) = (Realized_demand - Scenarios_mu_d(sub2ind(size(Scenarios_mu_d), Positions_l{:})))./(Scenarios_mu_d(sub2ind(size(Scenarios_mu_d), Positions_r{:})) - Scenarios_mu_d(sub2ind(size(Scenarios_mu_d), Positions_l{:})));
proportions(:,1) = 1-proportions(:,2);

Indices_of_points_from_convex_hull = (numbers(1,:)-1)*3^(T-1);
Probabilities_of_points_from_convex_hull = proportions(1,:);

for t = 2:T
    
    Indices_of_points_from_convex_hull = kron(Indices_of_points_from_convex_hull,[1 1]) + repmat(numbers(t,:)-1,[1 2^(t-1)])*3^(T-t);
    
    Probabilities_of_points_from_convex_hull = kron(Probabilities_of_points_from_convex_hull, proportions(t,:));
    
end

Indices_of_points_from_convex_hull = Indices_of_points_from_convex_hull + 1;

Orders = double(q(:,Indices_of_points_from_convex_hull))*Probabilities_of_points_from_convex_hull';
