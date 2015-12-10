USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectSummaryReport]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProjectSummaryReport]
	(
		@CompanyKey int,
		@UserKey int,
		@ProjectStatusKey int,
		@ClientKey int,
		@AccountManager int,
		@OfficeKey int
	)

As  --Encrypt

Declare @sSQL nvarchar(4000)


Select @sSQL = 'SELECT vp.*, ISNULL(vp.ProjectTypeKey, 0) as NoProjectTypeKey '
Select @sSQL = @sSQL + 'FROM vProjectBudgetSummary vp (nolock), tAssignment a (nolock) '
Select @sSQL = @sSQL + 'WHERE vp.ProjectKey = a.ProjectKey and vp.CompanyKey = '
Select @sSQL = @sSQL + cast(@CompanyKey as nvarchar) + ' AND a.UserKey = ' + cast(@UserKey as nvarchar)


	if @ProjectStatusKey = -1
		Select @sSQL = @sSQL + ' AND vp.Active = 1'
	else
		if @ProjectStatusKey = -2
			Select @sSQL = @sSQL + ' AND vp.Active = 0'
		else
			if @ProjectStatusKey > 0
				Select @sSQL = @sSQL + ' AND vp.ProjectStatusKey = ' + cast(@ProjectStatusKey as nvarchar)
			
	if @ClientKey > 0
		Select @sSQL = @sSQL + ' AND vp.ClientKey = ' + cast(@ClientKey as nvarchar)
		
	if @AccountManager > 0
		Select @sSQL = @sSQL + ' AND vp.AccountManager = ' + cast(@AccountManager as nvarchar)

	if @OfficeKey > 0
		Select @sSQL = @sSQL + ' AND vp.OfficeKey = ' + cast(@OfficeKey as nvarchar)

exec sp_executesql @sSQL
GO
