# -*- coding: utf-8 -*-
"""
Created on Tue Dec 15 13:28:35 2015

@author: Ward
"""

from gurobipy import *
from OR_problem_functions import *




    
"L-shaped parameters"
max_Iter = 1000        # Maximum number of L-shaped iterations
epsilon = 10**-5       # Absolute optimality criterion


" Data "
N = 15         # Number of surgery blocks and number of potential operating rooms (ORs) to open
cf = 1         # Fixed costs for opening an OR
cv = 0.0333    # Variable costs for overtime per minute
T  = 200      # The time an OR is normally in use (8 hours)

mu = range(N)  # Average duration of each surgery block
d  = range(N)  # Mean absolute deviations of each surgery block
a  = range(N)  # Left bound of the support of each surgery block
b  = range(N)  # Right bound of the support of each surgery block 

for i in range(N):                # Requires input from real data
    mu[i] = 90
    d[i]  = 10
    a[i]  = 30
    b[i]  = 150
    
p   = range(N)         # for each surgery blocks summarizes the worst-case probabilities of the worst-case distributions
w   = range(N)         # for each surgery blocks summarizes the outcomes of the worst-case distributions
for i in range(N):
    p[i] = range(3)
    w[i] = range(3)    

" Calculate worst-case distribution "
for i in range(N):
    p[i][0] = d[i]/(2.0*(mu[i]-a[i]))
    p[i][1] = 1 - d[i]/(2.0*(mu[i]-a[i])) - d[i]/(2.0*(b[i]-mu[i]))
    p[i][2] = d[i]/(2.0*(b[i]-mu[i]))

    w[i][0] = a[i]
    w[i][1] = mu[i]
    w[i][2] = b[i]
    

" Generate the master problem MP "
[MP,x,y,theta,Cuts,N_cuts] = Generate_Master_Problem(N,cf,cv,mu,T,a,b,d)
     # MP represents the optimization model
     # x determines whether an OR will be opened or not
     # y determines which surgery is assigned to which OR
     # theta gives a lower bound on the total minutes of overtime over all ORs
     # Cuts keeps track of the optimality cuts and N_cuts denotes the # of these cuts

" Initialize lower and upper bounds on the optimal objective value "
LB = 0
UB = 10**100

" Initialize the Iteration-counter "
Iter = 0

"Keep generating optimality cuts and reoptimizing until Optimality GAP < epsilon"
while Iter < max_Iter and (UB > LB + epsilon):
    Iter += 1
    " Optimize the master problem "
    MP.optimize()   
    " Save the current solution "
    [x_current,y_current] = Save_current_solution(N,x,y)
    " Calculate the # of opened ORs "
    Fixed_costs = cf*sum(x_current[j] for j in range(N))
    " Update the lower bound "
    LB = MP.ObjVal
    " Calculate the overtime Q per OR j and generate an optimality cut "
    [MP,Cuts,N_cuts,Q] = Generate_Cuts(N,x,y,theta,MP,w,p,T,Cuts,N_cuts,cv)
    " Update the upper bound and display information on current solution"
    UB = min(UB,cf*sum(x_current[j] for j in range(N)) +cv*sum(Q[j] for j in range(N)))
    print "Iteration:", Iter, "     LB =", LB, "    UB =", UB, "   FC =", Fixed_costs,"    N_cuts:", N_cuts


Display_current_MP_Sol(N,x_current,y_current,Q,MP,cv,cf)






