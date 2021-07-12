% Pareto stripe 3 plots on one

figure(2)

for iterate_instance = 1:3
    subplot(3,1,iterate_instance);
    Pareto_stripe_plotting;
end