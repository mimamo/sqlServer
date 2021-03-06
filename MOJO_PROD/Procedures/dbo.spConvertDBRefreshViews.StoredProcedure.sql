USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDBRefreshViews]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDBRefreshViews]

AS

/*
|| When      Who Rel      What
|| 12/10/09  GHL 10.5.1.4 Check that the view starts with dbo.v
|| 12/22/09  GWG 10.5.1.5 Removed the check
|| 5/15/10   GWG 10.5.2.2 Added a check for v only on the beginning cause name does not give dbo.
*/

declare @id as integer
declare @name as varchar(250)
declare @sql as varchar(500)
declare @verbose as integer
 

select @id = -1
while (1=1)
begin

	select @id = min(id)
	from sysobjects where xtype = 'V'
	and id > @id

	if @id is null
		break

	select @name = name
	from sysobjects where xtype = 'V'
	and id = @id

	if charindex('v',@name) = 1 
	BEGIN
	select @sql = 'sp_refreshview ' + @name

	exec (@sql)
	--print 'Refreshing ' + @name
	END
	 
end
GO
