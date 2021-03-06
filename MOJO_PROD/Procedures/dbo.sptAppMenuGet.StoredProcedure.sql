USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppMenuGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAppMenuGet]
	
	(
	@UserKey int,
	@AllItems tinyint
	)

AS

Declare @CompanyKey int, @SecurityGroupKey int,  @Admin int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), @SecurityGroupKey = SecurityGroupKey, @Admin = Administrator from tUser (nolock) Where UserKey = @UserKey

if not exists(Select 1 from tAppMenu (nolock) Where (Entity = 'User' and EntityKey = @UserKey) OR (Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey))
	Select @AllItems = 1

if @AllItems = 1
BEGIN
	-- load the full menus
	if @Admin = 2
		Select AppMenuKey, FolderKey, Label, Icon, ActionID, NewActionID, DisplayOrder
		from tAppMenu am (nolock) 
		Where Entity = 'System'
		Order By FolderKey, DisplayOrder

	ELSE
	
		Select AppMenuKey, FolderKey, Label, Icon, ActionID, Case When HasNewRight = 1 then NewActionID else NULL end as NewActionID, DisplayOrder
		From (
			Select am.*,
			Case When RightID is null then 1 else (Select 1 from tRightAssigned ra (nolock) inner join tRight r (nolock) on r.RightKey = ra.RightKey 
														Where EntityKey = @SecurityGroupKey and r.RightID = am.RightID) end as HasRight,
			Case When NewRightID is null then 1 else (Select 1 from tRightAssigned ra (nolock) inner join tRight r (nolock) on r.RightKey = ra.RightKey 
														Where EntityKey = @SecurityGroupKey and r.RightID = am.NewRightID) end as HasNewRight
			from tAppMenu am (nolock) 
			Where Entity = 'System' ) as tbl
		Where ActionID is null OR HasRight = 1
		Order By FolderKey, DisplayOrder

	
END
ELSE
BEGIN


	if exists(Select 1 from tAppMenu (nolock) Where Entity = 'User' and EntityKey = @UserKey)
	BEGIN
	
		if @Admin = 1
			Select AppMenuKey, FolderKey, Label, Icon, ActionID, NewActionID, DisplayOrder
			from tAppMenu am (nolock) 
			Where Entity = 'User' and EntityKey = @UserKey
			Order By FolderKey, DisplayOrder
		else
			Select AppMenuKey, FolderKey, Label, Icon, ActionID, Case When HasNewRight = 1 then NewActionID else NULL end as NewActionID, DisplayOrder
			From (
				Select am.*,
				Case When RightID is null then 1 else (Select 1 from tRightAssigned ra (nolock) inner join tRight r (nolock) on r.RightKey = ra.RightKey 
															Where EntityKey = @SecurityGroupKey and r.RightID = am.RightID) end as HasRight,
				Case When NewRightID is null then 1 else (Select 1 from tRightAssigned ra (nolock) inner join tRight r (nolock) on r.RightKey = ra.RightKey 
															Where EntityKey = @SecurityGroupKey and r.RightID = am.NewRightID) end as HasNewRight
				from tAppMenu am (nolock) 
				Where Entity = 'User' and EntityKey = @UserKey) as tbl
			Where ActionID is null OR HasRight = 1
			Order By FolderKey, DisplayOrder
		

	END
	ELSE
	BEGIN
	
		if @Admin = 1
			Select AppMenuKey, FolderKey, Label, Icon, ActionID, NewActionID, DisplayOrder
			from tAppMenu am (nolock) 
			Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey
			Order By FolderKey, DisplayOrder
		else
			Select AppMenuKey, FolderKey, Label, Icon, ActionID, Case When HasNewRight = 1 then NewActionID else NULL end as NewActionID, DisplayOrder
			From (
				Select am.*,
				Case When RightID is null then 1 else (Select 1 from tRightAssigned ra (nolock) inner join tRight r (nolock) on r.RightKey = ra.RightKey 
															Where EntityKey = @SecurityGroupKey and r.RightID = am.RightID) end as HasRight,
				Case When NewRightID is null then 1 else (Select 1 from tRightAssigned ra (nolock) inner join tRight r (nolock) on r.RightKey = ra.RightKey 
															Where EntityKey = @SecurityGroupKey and r.RightID = am.NewRightID) end as HasNewRight
				from tAppMenu am (nolock) 
				Where Entity = 'SecurityGroup' and EntityKey = @SecurityGroupKey) as tbl
			Where ActionID is null OR HasRight = 1
			Order By FolderKey, DisplayOrder

	END

END
GO
