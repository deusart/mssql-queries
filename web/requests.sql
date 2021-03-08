/* =============================================
Author:			Dmitry Tavakalov
Create date:	08-03-2021
Description:	http requests
Examples:		
============================================= */

SET ANSI_NULLS ON GO
SET QUOTED_IDENTIFIER ON GO

IF NOT EXISTS (select 1 from sys.schemas where name = 'web1')
	EXEC('CREATE SCHEMA [web1] AUTHORIZATION [dbo]')



DROP PROCEDURE IF EXISTS web.request;
CREATE PROCEDURE web.request(
	@url varchar(max)	
	, @return_type varchar(6) = 'json' -- 'json', 'list'
	, @request_type varchar(6) = 'get'-- get
	)
AS
BEGIN

	SET NOCOUNT ON;

	declare @obj int
    declare @hr  int
    declare @msg varchar(max)

    exec @hr = sp_OACreate 'MSXML2.ServerXMLHttp', @obj OUT
    if @hr <> 0 begin set @msg = 'sp_OACreate MSXML2.ServerXMLHttp.3.0 failed' return @msg end

    exec @hr = sp_OAMethod @obj, 'open', NULL, 'GET', @url, false
    if @hr <> 0 begin set @msg = 'sp_OAMethod Open failed' goto eh end

    exec @hr = sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Type', 'application/x-www-form-urlencoded'
    if @hr <> 0 begin set @msg = 'sp_OAMethod setRequestHeader failed' goto eh end

    exec @hr = sp_OAMethod @obj, send, NULL, ''
    if @hr <> 0 begin set @msg = 'sp_OAMethod Send failed' goto eh end
	
	
END
