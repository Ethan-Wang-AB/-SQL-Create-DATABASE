set echo on
set linesize 132
set pagesize 66

--drop tables if there are mistakenl created
drop TABLE type cascade constraints;
drop TABLE manager cascade constraints;
drop TABLE entertainer cascade constraints;
drop TABLE musicalStyles cascade constraints;
drop TABLE entertainerMusicalStyles cascade constraints;
drop TABLE agent cascade constraints;
drop TABLE client cascade constraints;
drop TABLE entertainerGig cascade constraints;

create table agent (
agentid number,
firstName varchar2(25),
lastName varchar2(25),
hireDate date,
busPhone char(12),
homePhone char(12),
email varchar2(60)
);
alter table agent
	add constraint sys_agent_pk primary key (agentID)
	modify (firstName constraint sys_agent_firstName_nn not null)
	modify (lastName constraint sys_agent_lastName_nn not null)
	modify (busPhone constraint sys_agent_busPhone_nn not null)
	add constraint sys_agent_email_uk unique (email)
	modify (email constraint sys_agent_email_nn not null);

--create table with attributes and constraints

create table manager (
managerID number primary key,
firstName varchar2(25) constraint sys_manager_firstName_nn not null,
lastName varchar2(25) constraint sys_manager_lastName_nn not null,
busName varchar2(50) constraint sys_manager_busName_nn not null,
homePhone char(12),
busPhone char(12) constraint sys_manager_busPhone_nn not null,
email varchar2(60) constraint sys_manager_email_nnuk not null unique
);

--create table with constraints

create table type (
entertainerTypeID number primary key,
description varchar2(50) constraint sys_type_desc_nn not null
);

--create table with constraints

create table musicalStyles (
styleID number,
description varchar2(50) constraint sys_musicalStyles_description_nn not null,
constraint sys_musicalStyles_pk primary key (styleID)
);

--create table without constraints
create table client (
clientID number,
agentID number,
firstName varchar2(25),
lastName varchar2(25),
busPhone char(12),
email varchar2(60)
);


--add constraints by adding alter command
alter table client 
	add constraint sys_client_pk primary key (clientID)
	add constraint sys_client_agent_fk foreign key (agentID) references agent(agentID)
	modify (firstName constraint sys_client_fistName_nn not null)
	modify (lastName constraint sys_client_lastName_nn not null)
	modify (busPhone constraint sys_client_busPhone_nn not null)
	add constraint sys_client_email_uk unique (email)
	modify (email constraint sys_client_email_nn not null);
	
--creating table with constraints

create table entertainer (
homePhone char(12),
entertainerID number,
entertainerTypeID number,
managerID number constraint sys_entertainer_managerID_nn not null,
firstName varchar2(25) constraint sys_entertainer_firstName_nn not null,
lastName varchar2(25) constraint sys_entertainer_lastName_nn not null,
stageName varchar2(50) constraint sys_entertainer_stageName_nn not null,
busPhone char(12) constraint sys_entertainer_busPhone_nn not null,
email varchar2(60) constraint sys_entertainer_email_nnuk not null unique,
constraint sys_entertainer_pk primary key (entertainerID),
constraint sys_entertainer_type_fk foreign key (entertainerTypeID) references type(entertainerTypeID),
constraint sys_entertainer_manager_fk foreign key (managerID) references manager(managerID)
);



create table entertainerMusicalStyles (
styleID number,
entertainerID number,
constraint sys_entertainerMusicalStyles_pk primary key(styleID, entertainerID),
constraint sys_entertainerMusicalStyles_musicalStyles_fk1 foreign key (styleID) references musicalStyles(styleID),

constraint sys_entertainerMusicalStyles_entertainer_fk2 foreign key (entertainerID) references entertainer(entertainerID)
);

--create table with some table level constraints
create table entertainerGig (
entertainerID number,
clientID number,
startDate date,
clientFee number(7,2),
entertainerFee number(7,2),
street varchar2(50) constraint sys_entertainerGig_street_nn not null,
city varchar2(25) constraint sys_entertainerGig_city_nn not null,
prov varchar2(2) constraint sys_entertainerGig_prov_nn not null,
postalCode char(6) constraint sys_entertainerGig_postalCode_nn not null,
constraint sys_entertainerGig_pk primary key (entertainerID, clientID, startDate),
constraint sys_entertainerGig_entertainer_fk foreign key (entertainerID) references entertainer(entertainerID),
constraint sys_entertainerGig_client_fk foreign key (clientID) references client(clientID),
constraint sys_entertainerGig_clientFee_ck check (clientFee >= entertainerFee),
constraint sys_entertainerGig_prov_ck check (prov in ('AB', 'BC', 'MB', 'NB', 'NL', 'NS', 'NT', 'NU', 'ON', 'PE', 'QC', 'SK', 'YT'))
);



--alter constraints by adding constraints using alter command

alter table agent 
	add constraint sye_homePhone_agent_regex check (homePhone like '[0-9]{3}[-.][0-9]{3}[-.][0-9]{4}')
	add constraint sys_busPhone_agent_regex check (busPhone like '[0-9]{3}[-.][0-9]{3}[-.][0-9]{4}');
	
alter table entertainer
	add constraint sys_homePhone_entertainer_regex check (homePhone like '[0-9]{3}[-.][0-9]{3}[-.][0-9]{4}')
	add constraint sys_busPhone_entertainer_regex check (busPhone like '[0-9]{3}[-.][0-9]{3}[-.][0-9]{4}');
	
alter table manager
	add constraint sys_homePhone_manager_regex check (homePhone like '[0-9]{3}[-.][0-9]{3}[-.][0-9]{4}')
	add constraint sys_busPhone_manager_regex check (busPhone like '[0-9]{3}[-.][0-9]{3}[-.[0-9]{4}');
	
alter table client
	add constraint sys_busPhone_client_regex check (busPhone like '[0-9]{3}[-.][0-9]{3}[-.][0-9]{4}');
	
alter table entertainerGig
	add constraint sys_postalCode_entertainerGig_regex check (postalCode like '[A-Z]{1}[0-9]{1}[A-Z]{1}[0-9]{1}[A-Z]{1}[0-9]{1}');



