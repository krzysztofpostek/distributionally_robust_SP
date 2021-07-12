
Columns_indices = [2 13];

First_table = round([mean(Objectives_worst_case(:,Columns_indices))
                mean(Objectives_worst_case_mu(:,Columns_indices))
                mean(Objectives_worst_case_mu_d(:,Columns_indices))
                reshape(mean(Objectives_best_case_together(:,Columns_indices,:)),[length(Columns_indices) 3])'
                mean(mean(Results_simulation_uniform(:,Columns_indices,:),1),3)
                mean(std(Results_simulation_uniform(:,Columns_indices,:),1,1),3)
                mean(mean(Results_simulation_mu(:,Columns_indices,:),1),3)
                mean(std(Results_simulation_mu(:,Columns_indices,:),1,1),3)
                mean(mean(Results_simulation_mu_d(:,Columns_indices,:),1),3)
                mean(std(Results_simulation_mu_d(:,Columns_indices,:),1,1),3)])
                           
Columns_indices = [2 6 4];
            
Second_table = round([mean(Objectives_worst_case(:,Columns_indices))
                mean(Objectives_worst_case_mu(:,Columns_indices))
                mean(Objectives_worst_case_mu_d(:,Columns_indices))
                reshape(mean(Objectives_best_case_together(:,Columns_indices,:)),[length(Columns_indices) 3])'
                mean(mean(Results_simulation_uniform(:,Columns_indices,:),1),3)
                mean(std(Results_simulation_uniform(:,Columns_indices,:),1,1),3)
                mean(mean(Results_simulation_mu(:,Columns_indices,:),1),3)
                mean(std(Results_simulation_mu(:,Columns_indices,:),1,1),3)
                mean(mean(Results_simulation_mu_d(:,Columns_indices,:),1),3)
                mean(std(Results_simulation_mu_d(:,Columns_indices,:),1,1),3)])
            
 First_table_relative = (First_table-repmat(First_table(:,1),[1 size(First_table,2)]))./repmat(First_table(:,1),[1 size(First_table,2)])*100
 
 Second_table_relative = (Second_table-repmat(Second_table(:,1),[1 size(Second_table,2)]))./repmat(Second_table(:,1),[1 size(Second_table,2)])*100