/* =============================================
Author:			
	Dmitry Tavakalov
Create date:	
	08-03-2021
Description:
	Query for creation function to get http requests.
	Current version v0.01
Examples:	
============================================= */

if not exists (select 1 from sys.schemas where name = 'web')
	exec('CREATE SCHEMA web AUTHORIZATION dbo')
go

drop function if exists web.get_json;
go

create function web.get_json(@url varchar(max))
returns varchar(max)
as
begin
    declare @obj int;
    declare @hr  int;
    declare @msg varchar(8000);

    exec @hr = sp_OACreate 'MSXML2.ServerXMLHttp', @obj OUT;
    if @hr <> 0 begin set @msg = 'sp_OACreate MSXML2.ServerXMLHttp.3.0 failed' return @msg end;

    exec @hr = sp_OAMethod @obj, 'open', NULL, 'GET', @url, false;
    if @hr <> 0 begin set @msg = 'sp_OAMethod Open failed' goto eh end;

    exec @hr = sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Type', 'application/x-www-form-urlencoded';
    if @hr <> 0 begin set @msg = 'sp_OAMethod setRequestHeader failed' goto eh end;

    exec @hr = sp_OAMethod @obj, send, NULL, '';
    if @hr <> 0 begin set @msg = 'sp_OAMethod Send failed' goto eh end;

    exec @hr = sp_OAGetProperty @obj,'ResponseText',@msg output
    IF @hr <> 0 exec sp_OAGetErrorInfo @obj;

    goto eh;

    eh:
    exec @hr = sp_OADestroy @obj;
    return @msg;
end

