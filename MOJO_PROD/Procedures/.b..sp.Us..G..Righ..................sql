USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetRight]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetRight]

	(
		@UserKey int,
		@RightID varchar(50)
	)

AS --Encrypt

Declare @SecurityGroupKey int, @Admin tinyint

Select @SecurityGroupKey = SecurityGroupKey, @Admin = Administrator from tUser (NOLOCK) Where UserKey = @UserKey

if @Admin = 1
	return 1

if @SecurityGroupKey is null
	return 0
	
if exists(select 1 from tRightAssigned ra (nolock)
	inner join tRight r (nolock) on ra.RightKey = r.RightKey
	Where	ra.EntityType = 'Security Group' 
	and		ra.EntityKey = @SecurityGroupKey
	and		UPPER(r.RightID) = UPPER(@RightID))
	return 1
else
	return 0
GO
