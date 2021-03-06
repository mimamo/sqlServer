USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppSessionGetUserSettings]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppSessionGetUserSettings]
(
	@UserKey int,
	@GroupID varchar(200)
)

AS

/*
|| When      Who Rel      What
|| 3/20/15   GWG 10.5.9.0 Now unions in any user session settings for the group.
*/

/*
	Every row has to exist in tAppSession with a 'system' entity. This defines the default
*/

Declare @SecurityGroupKey int, @CompanyKey int

Select @SecurityGroupKey = SecurityGroupKey, @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (nolock) Where UserKey = @UserKey


If exists(Select 1 from tAppSession (nolock) Where Entity = 'securitygroup' and EntityKey = @SecurityGroupKey and GroupID = @GroupID)
BEGIN
	Select aset.SessionID, ISNULL(us.Value, ISNULL(apps.Value, aset.DefaultValue)) as Value
	From tAppSetting aset (nolock) 
	left outer join (Select * from tAppSession (nolock) Where Entity = 'securitygroup' and EntityKey = @SecurityGroupKey and GroupID = @GroupID) as apps on aset.SessionID = apps.SessionID
	left outer join (Select * from tAppSession (nolock) Where Entity = 'user' and EntityKey = @UserKey and GroupID = @GroupID) as us on aset.SessionID = us.SessionID
	Where aset.GroupID = @GroupID
	
	
	UNION ALL
	
	Select SessionID, Value 
	From tAppSession s (NOLOCK) 
	Where GroupID = @GroupID and EntityKey = @UserKey and Entity = 'user' and SessionID not in (Select SessionID from tAppSetting Where GroupID = @GroupID)
	
END
ELSE
BEGIN
-- otherwise drop back to the company settings
	Select aset.SessionID, ISNULL(us.Value, ISNULL(apps.Value, aset.DefaultValue)) as Value
	From tAppSetting aset (nolock) 
	left outer join (Select * from tAppSession (nolock) Where Entity = 'company' and EntityKey = @CompanyKey and GroupID = @GroupID) as apps on aset.SessionID = apps.SessionID
	left outer join (Select * from tAppSession (nolock) Where Entity = 'user' and EntityKey = @UserKey and GroupID = @GroupID) as us on aset.SessionID = us.SessionID
	Where aset.GroupID = @GroupID
	
	UNION ALL
	
	Select SessionID, Value 
	From tAppSession s (NOLOCK) 
	Where GroupID = @GroupID and EntityKey = @UserKey and Entity = 'user' and SessionID not in (Select SessionID from tAppSetting Where GroupID = @GroupID)
END
GO
