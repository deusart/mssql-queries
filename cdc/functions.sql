if not exists (select 1 from sys.schemas where name = 'cdc')
	exec('CREATE SCHEMA cdc AUTHORIZATION dbo')
go

drop function if exists cdc.hash_diff;
go

create function cdc.hash_diff(@input nvarchar(max))
returns binary(16)
as
begin
	return cast(HASHBYTES('MD5', @input) as binary(16))
end
go