if not exists (select 1 from sys.schemas where name = 'web')
	exec('CREATE SCHEMA web AUTHORIZATION dbo')
go

create type [web].[json_table] as table(
	[key] [nvarchar](250) NULL
	, [value] [nvarchar](max) NULL
	, [type] [nvarchar](20) NULL
)
go

create type [web].[list_table] as table(
	[id] [nvarchar](250) NOT NULL
)
go