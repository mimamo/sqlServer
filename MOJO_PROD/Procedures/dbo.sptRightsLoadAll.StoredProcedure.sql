USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightsLoadAll]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightsLoadAll]

	(
	@UserKey int,
	@SetGroup varchar(50) = NULL,
	@RightID varchar(50) = NULL
	)
	
AS


Declare @RightLevel int, @CompanyKey int, @SecurityGroupKey int, @Admin tinyint, @ClientLogin tinyint

Select @RightLevel = ISNULL(RightLevel, 0), @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), 
		@SecurityGroupKey = SecurityGroupKey, @Admin = ISNULL(Administrator, 0), @ClientLogin = ISNULL(ClientVendorLogin, 0)
		from tUser (nolock) Where UserKey = @UserKey

if @RightID is null
	if @SetGroup is null
		if @ClientLogin = 1
			Select @SetGroup = 'client'
		else
			select @SetGroup = 'admin'

if @Admin = 1
BEGIN
	Select r.*, 1 as Allowed
	From tRight r (nolock)
	Where 
		(@SetGroup is null or r.SetGroup = @SetGroup) 
		AND (@RightID is null or r.RightID = @RightID)
END
ELSE
BEGIN
	if @RightLevel = 0
		Select r.*, ISNULL(ra.Allowed, 0) as Allowed
		from tRight r (nolock)
		left outer join 
			(Select RightKey, 1 as Allowed
				from tRightAssigned (nolock)
				Where EntityType = 'Security Group' and EntityKey = @SecurityGroupKey) as ra on r.RightKey = ra.RightKey
		Where 
			(@SetGroup is null or r.SetGroup = @SetGroup) 
			AND (@RightID is null or r.RightID = @RightID)
	else
		Select r.*
		from tRight r (nolock)
		left outer join 
			(Select RightKey, 1 as Allowed
				from tRightAssigned (nolock)
				Where EntityType = 'Security Group' and EntityKey = @SecurityGroupKey) as ra on r.RightKey = ra.RightKey
		inner join tRightLevel rl (nolock) on r.RightKey = rl.RightKey and rl.CompanyKey = @CompanyKey
		Where 
			(@SetGroup is null or r.SetGroup = @SetGroup) 
			AND (@RightID is null or r.RightID = @RightID)
END



 /* set nocount on */
 return 1
GO
