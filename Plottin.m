
figure(1)
plot([1:50]',SP_convexity_status/364*100)
legend('Convex','Linear','Concave');
xlabel('Instance');
ylabel('Share of decisions');


figure(2)

plot(Objectives_worst_case(iterate_instance,1) +(Objectives_worst_case(iterate_instance,13) - Objectives_worst_case(iterate_instance,1))*[0:50]'/50,[Worst_case_curve Best_case_curve]);
xlabel('Worst-case upper limit');
ylabel('Expectation');
legend('Upper bound','Lower bound');

figure(3)
plot([1:50]',SP_convexity_status_weighted./repmat(sum(SP_convexity_status_weighted,2),[1 3])*100)
legend('Convex','Linear','Concave');
xlabel('Instance');
ylabel('Share of decisions');
