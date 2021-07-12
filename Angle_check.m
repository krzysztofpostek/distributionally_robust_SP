% This file computes the angle of the optimal decisions...

% Convexity check

Angles_instance = zeros(T,N_bins_histogram+1);

iterate_triplet = 1;

for t=2:T
    
    Angles_list_per_T = zeros(3^(t-2),1);
    
    iterate_triplet = 1;
    
    for n_triplets = 0:3^(t-2)-1
        
        Decisions_triplet = double(q(t,n_triplets*(3^(T+2-t))+[1 2 3]*3^(T-t+1)));
        
        Decisions_couple = [(lb(t) - mus(t)) (ub(t) - mus(t)) ; (Decisions_triplet(1)- Decisions_triplet(2)) (Decisions_triplet(3)- Decisions_triplet(2))];
        
        angle = acos(Decisions_couple(:,1)'*Decisions_couple(:,2)/norm(Decisions_couple(:,1))/norm(Decisions_couple(:,2)));
        
        if(Decisions_couple(2,1)/Decisions_couple(1,1) > Decisions_couple(2,2)/Decisions_couple(1,2))
            angle = 2*pi - angle;
        end
        
        Angles_list_per_T(iterate_triplet) = angle;
        
        iterate_triplet = iterate_triplet + 1;
        
    end
    
    Angles_instance(t,:) = histc(Angles_list_per_T,linspace(0,2*pi,N_bins_histogram+1));
    
end