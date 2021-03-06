USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightAssignedGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightAssignedGet]
 @UserKey int,
 @RightID varchar(50)
AS --Encrypt


If Exists(Select 1 From tUser (nolock) Where UserKey = @UserKey and Administrator = 1)
	Return 1


if Exists(Select 1 from tUser u (nolock)
	inner join tRightAssigned ra (nolock) on u.SecurityGroupKey = ra.EntityKey
	inner join tRight r (nolock) on ra.RightKey = r.RightKey
	Where u.UserKey = @UserKey and r.RightID = @RightID)
BEGIN
		Return 1
END

Return 0
GO
