# -*- coding: utf-8 -*-
"""
Created on Tue Dec 15 13:40:23 2015

@author: Ward
"""

from gurobipy import *




def Generate_Master_Problem(N,cf,cv,mu,T,a,b,d):
    MP = Model("Master problem for OR Scheduling")
    
    " Define variables "
    x = {}                  # Determines whether we should open OR j
    y = {}                  # Determines whether surgery i is performed in OR j
    
    for j in range(N):
        x[j]     = MP.addVar(lb=0,ub=1,vtype = GRB.BINARY, obj = cf, name = "x_"+str(j))
    
    theta = MP.addVar(lb=0,ub=GRB.INFINITY,vtype = GRB.CONTINUOUS, obj = cv, name = "theta")
         # Determines a lower bound for the total overtime in minutes over all ORs
    
    MP.update()
        
    for i in range(N):
        for j in range(N):
            y[i,j] = MP.addVar(lb=0,ub=1,vtype = GRB.BINARY, obj = 0, name = "y_"+str(i)+"_"+str(j))
        
    MP.update()

    
    " Define constraints "
    # Every surgery i is allocated to an OR
    for i in range(N):    
        MP.addConstr(quicksum(y[i,j] for j in range(N)) == 1)
        
    # A surgery i can only be allocated to OR j if this OR is opened    
    for i in range(N):
        for j in range(N):
            MP.addConstr(y[i,j] <= x[j])
            
    # Symmetry breaking constraints: First open OR 1, then OR 2,...        
    for j in range(N):
        if j <> (N-1):
            MP.addConstr(x[j] >= x[j+1])    
            
    for i in range(N):
        for j in range(N):
            if i >= j:
                if j > 0:
                    MP.addConstr(y[i,j] <= quicksum(y[k,j-1] for k in range(N) if k <= i-1 if k >= j-1))
    
    for i in range(N):
        MP.addConstr(quicksum(y[i,j] for j in range(N) if j <= i) == 1)
            
    # Symmetry breaking contraints for identical surgeries
    for i in range(N):
        for i2 in range(N):
            for j in range(N):
                if i < i2:
                    if (a[i]==a[i2])and(mu[i]==mu[i2])and(d[i]==d[i2])and(b[i]==b[i2]):
                        MP.addConstr(quicksum(y[i,k] for k in range(j)) >= quicksum(y[i2,k] for k in range(j)))
                
    MP.update()
    
    # Initial lower bound on total minutes of overtime per OR (using average surgery times)
    MP.addConstr(theta >= quicksum(mu[i]*y[i,j] for i in range(N) for j in range(N))-T*quicksum(x[j] for j in range(N)))
    
    MP.update()
    
    
    " Set optimization parameters "
    MP.modelSense = GRB.MINIMIZE
    MP.setParam( 'OutputFlag', False )  # Do not 
    MP.update()    
    
    
    " Initialize set of Optimality Cuts "
    Cuts = {}                # Initialize set of Optimality cuts
    N_cuts = 0               # Initialize number of Optimality cuts
    
    return [MP,x,y,theta,Cuts,N_cuts]







def Generate_Cuts(N,x,y,theta,MP,w,p,T,Cuts,N_cuts,cv):
    " Initialize output parameters "
    Q = range(N)                 # Q denotes the minutes of overtime per OR j
    x_coeff = {}                 # x_coeff denotes the coefficient of x in the optimality cut
    y_coeff = {}                 # y_coeff denotes the coefficient of y in the optimality cut
    for j in range(N):
        Q[j] = 0
    for k in range(N):
        x_coeff[k] = 0 
        for i in range(N):
            y_coeff[i,k] = 0
            
    " Calculate the output parameters for each OR j separately "       
    for j in range(N):
        " Only if OR j is open, the output parameters may be positive "
        if x[j].x > 0:
            
            " Calculate which surgeries are performed in OR j "
            SCEN = []
            for i in range(N):
                if abs(y[i,j].x-1) < 10**-5:
                    SCEN = SCEN + [i]
            Ns = len(SCEN)     # Number of surgeries in OR j    
            
            "Calculate overtime in OR j and corresponding optimality cut coefficients "
            [x_coeff,y_coeff,Q] = Calculate_coefficients(j,x_coeff,y_coeff,Q,Ns,SCEN,T,w,p)                
     
        
    " Add optimality cut to MP model "       
    Cuts[N_cuts] = MP.addConstr(theta >= (quicksum(x_coeff[j]*x[j] for j in range(N))+quicksum(y_coeff[i,j]*y[i,j] for i in range(N) for j in range(N))))                
    N_cuts += 1      
                
    MP.update()
    
    return [MP,Cuts,N_cuts,Q]
                
    

def Calculate_coefficients(j,x_coeff,y_coeff,Q,Ns,SCEN,T,w,p):
    " Only adjust output parameters if there are surgeries performed in OR j "
    if Ns > 0:
        
        " Initialize data tree for efficient calculation of expected overtime " 
        Nodes = {}   # Dictionary containing information about each node
        N_node = 0   # Number of Nodes
        Nodes[0] = [-1,[],1,0,sum(w[SCEN[i]][2] for i in range(Ns)),sum(w[SCEN[i]][0] for i in range(Ns)),-1]
            # the root nodes is 0
            # For every node:
            # Element 0: level (number of surgeries already taken into account)
            # Element 1: Previous nodes (values selected for each previous surgery (0,1,2)) 
            # Element 2: Probability that one of the subnodes of the current node occurs (for the root node p = 1)
            # Element 3: Current duration of the surgeries (sum of all activities already taken into account)
            # Element 4: Maximum duration of all surgeries not yet taken into account
            # Element 5: Minimum duration of all surgeries not yet taken into account
        TREE = [0]     # List of Nodes
                
        while len(TREE)>0:
            " Select current node "
            r = TREE[0]     
            
            " If current node is a leave of the tree "
            if Nodes[r][0]==(Ns-1):
                " If surgery duration exceeds T, update coefficients"
                if Nodes[r][3] > T:
                    Nodes[r][6] = 1
                    Q[j] += Nodes[r][2]*(Nodes[r][3] - T)
                    x_coeff[j] += -Nodes[r][2]*T
                    for i in range(Ns):
                        y_coeff[SCEN[i],j] += Nodes[r][2]*w[SCEN[i]][Nodes[r][1][i]]
                else:
                    " If surgery durations do not exceed T, no updates necessary"    
                    Nodes[r][6] = 0
                del TREE[0]    
            else:
                " If not a leave, check if total durations will always be below T "   
                if Nodes[r][3]+Nodes[r][4] <= T:
                    "No updates necessary"    
                    Nodes[r][6] = 0 #always
                    del TREE[0]
                    "Check whether total duration is always above T"    
                if Nodes[r][3]+Nodes[r][5] >= T:
                    "Update coefficients using mean values for surgeries not taken into account "                    
                    Nodes[r][6] = 1 #always
                    avg_surg_time = Nodes[r][3]
                    for k in range(Nodes[r][0]+1, Ns):
                        avg_surg_time += w[SCEN[k]][1]
                    Q[j] += Nodes[r][2]*(avg_surg_time - T)
                    x_coeff[j] += -Nodes[r][2]*T
                    for i in range(Ns):
                        if i <= Nodes[r][0]:
                            y_coeff[SCEN[i],j] += Nodes[r][2]*w[SCEN[i]][Nodes[r][1][i]]
                        else:
                            y_coeff[SCEN[i],j] += Nodes[r][2]*w[SCEN[i]][1] 
                    del TREE[0]
                "If above test are inconclusive, consider all three possibilities for the next surgery"    
                if (Nodes[r][3]+Nodes[r][5] < T) and (Nodes[r][3]+Nodes[r][4] > T):    
                    "Add three nodes to the TREE which are one level higher than the root node"                    
                    for i in range(3):
                        N_node += 1
                        level = Nodes[r][0] + 1
                        k = SCEN[level]
                        Nodes[N_node] = [level,Nodes[r][1]+[i],Nodes[r][2]*p[k][i],Nodes[r][3] + w[k][i],Nodes[r][4] - w[k][2],Nodes[r][5] - w[k][0],-1]
                        TREE += [N_node]
                    del TREE[0]     
                    "repeat the procedure above until all scenarios are considered (then TREE  =[]) "   
  
    return [x_coeff,y_coeff,Q]   
  
    
   


 
def Display_current_MP_Sol(N,x,y,Q,MP,cv,cf):
    print ""
    for j in range(N):
        print "x_"+str(j), "=", x[j]
    
    print ""
        
        
         
    for i in range(N):
        for j in range(N):
            if y[i,j] > 0:
                print "y_"+str(i)+"_"+str(j), "=", y[i,j]
    
    print ""
    print "theta =", sum(Q[j] for j in range(N))
    
    print ""
    
    print ""
    print "Obj:", cf*sum(x[j] for j in range(N)) +cv*sum(Q[j] for j in range(N))  







   
     
    
def Save_current_solution(N,x,y):
    x_current = {}
    y_current = {}
    
    for j in range(N):
        x_current[j] = x[j].x
        for i in range(N):
            y_current[i,j] = y[i,j].x
            
    return [x_current,y_current]  
    

    
    
    
    
    
    
    
    