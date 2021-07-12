% Convexity check

Convexity_of_decisions_instance = zeros(T,3);

for t=2:T
    
    for n_triplets = 0:3^(t-2)-1
        
        Decisions_triplet = double(q(t,n_triplets*(3^(T+2-t))+[1 2 3]*3^(T-t+1)));

        if(Decisions_triplet(2) < -0.001 + 0.5*(Decisions_triplet(1)+Decisions_triplet(3)))

            Convexity_of_decisions_instance(t,1) = Convexity_of_decisions_instance(t,1) + 1;

            else
                if(Decisions_triplet(2) > +0.001 + 0.5*(Decisions_triplet(1)+Decisions_triplet(3)))

                    Convexity_of_decisions_instance(t,3) = Convexity_of_decisions_instance(t,3) + 1;

                else

                    Convexity_of_decisions_instance(t,2) = Convexity_of_decisions_instance(t,2) + 1;

                end
            end

        end
    
end