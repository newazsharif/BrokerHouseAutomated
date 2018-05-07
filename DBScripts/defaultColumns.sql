alter table tblBrokerBranch add 
	  active_status_id int not null default 1
	, membership_id numeric(9,0) not null default 62
	, changed_user_id nvarchar(128) not null --default '1bf1c0e7-fa04-4266-9ce4-d20d6516737a'
	, changed_date datetime not null default getdate()
	, is_dirty bit not null default 1