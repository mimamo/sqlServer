USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetWithRight]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetWithRight]
	(
		@CompanyKey int,
		@RightID varchar(100)
	)
AS --Encrypt
	

Select Distinct
	u.UserKey,
	u.FirstName + ' ' + u.LastName as UserName
From
	tUser u (nolock)
	inner join tRightAssigned ra (NOLOCK) on u.SecurityGroupKey = ra.EntityKey
	inner join tRight r (NOLOCK) on ra.RightKey = r.RightKey
Where
	u.CompanyKey = @CompanyKey and
	r.RightID = @RightID and
	u.Active = 1
GO
