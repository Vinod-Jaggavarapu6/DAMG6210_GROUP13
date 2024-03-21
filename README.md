# DAMG6210_GROUP13 DATABOSSES

WareFlex (Online marketplace for warehouses)

Objective: The objective is to serve as an online marketplace, facilitating seamless interaction between manufacturers and independent warehouse operators. The goal is to establish a system allowing companies to lease warehouse space for specific time frame.

Scripts Execution Order

1) Wallet_WAREHOUSEMGMT.zip - This is the cloud wallet that establishes connection to Oracle cloud database. The first step involves creation of a connection to the cloud database with the following credentials username: ADMIN and password: FinalProject1.

2) app_admin_setup.sql - The second step involves the creation of role WAREHOUSE_APP_ADMIN and granting neccessary privileges.Upon successful completion of role creation, WAREHOUSE_APP_ADMIN_USER  user is created with password BostonSpring2024#. The user is then assigned to the WAREHOUSE_APP_ADMIN role followed by granting priviliges to the user. Every time, before creation of any role or user, the system checks if the user or role exits and necessary actions are taken such as if the the role or user already exists it is dropped and indication to user or role creation is stated followed by the initiation of user or role creation.

3) cleanup.sql - Consists of scripts to clear objects such as sequences, tables and views. The third step involves elimination of already existing sequences, tables, views. With the help of names assigned to a particular table, view, sequence, the system checks the metadata if there is any existing sequence, table, view related to that name. if a particular sequence, table, view exists then that particular table, sequence, view is deleted.

4) sequences_creation.sql - Consists of scripts to generate sequences for unique differentiation of every record. The fourth step involves the creation of sequences for the tables. With the help of names assigned to a particular sequence, the system checks the metadata if there is any existing sequence related to that name. if a particular sequence exists then that particular sequence is deleted and if there isn't any then a sequence is created.

5) tables_creation.sql - Consists of scripts to generate tables. The fifth step involves creation of tables. With the help of names assigned to a particular table, the system checks the metadata if there is any existing table related to that name. if a particular table exists then that particular table is deleted and if there isn't any then a table is created. All the neccessary fields along with datatypes are generated. The appropriate sequences created in the above step are assigned. Keys are defined and relationships are built among tables. Constrainsts are placed on the fields to maintain data accuracy.

6) triggers_and_procedures.sql - The sixth step involves the creation of triggers and procedures throughtout the database. Every procedure is tailored to execute a series of operations and communicate manipulations among various tables when a particular change has occured. 

7) views.sql - Consists of scripts to create views for easing interpretability. The seventh step involves creation of views for various stakeholders associated with the database. The scripts involve picking numerous fields from various tables, aggrgating the data if needed, including mini procedures such as case statements for translating the data according to use preferences and combining them through joins thereby showcasing them as a single entity. 

8) users_roles_creation.sql - The eigth step involves creation of roles and respective users. Every time before creation of any role or user, the system checks if the user or role exits and necessary actions are taken such as if the the user or role already exists it is dropped and indication to user or role creation is stated followed by the initiation of user or role creation. Every time a role or user is created, neceesary privileges are granted. A user can only be assigned to a particular role if the role already exists. While creation of the user, the user must be given access to a particular role. There are three roles namely WAREHOUSE_OWNER, WAREHOUSE_CUSTOMER, WAREHOUSE_EMPLOYEE and three users namely WAREHOUSE_OWNER_USER (Password: BostonSpring2024#),WAREHOUSE_CUSTOMER_USER (Password: BostonSpring2024#), WAREHOUSE_EMPLOYEE_USER (Password: BostonSpring2024#).

9) data_insertion.sql - Consists of scripts to inject records in the concerned tables. The final step involves inserting data into the database using insert syntax and target table name.

