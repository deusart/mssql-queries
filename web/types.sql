drop type if exists web.json_table;
create type web.json_table as table 
(
	[key] nvarchar(250) null,
	[value] nvarchar(max) null,
	[type]  nvarchar(20) null
);
go

drop type if exists web.list_table;
create type web.list_table as table 
(
	[id] nvarchar(250) not null
);
go