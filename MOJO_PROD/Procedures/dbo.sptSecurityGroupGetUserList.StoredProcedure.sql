USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSecurityGroupGetUserList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSecurityGroupGetUserList]

	(
		@SecurityGroupKey int,
		@CompanyKey int
	)

AS

/*
|| When     Who Rel   What
|| 10/20/06 CRG 8.35  Added restriction for only Active users.
*/

Select	ISNULL(FirstName + ' ', '') 
		+ ISNULL((LEFT(ISNULL(MiddleName, ''), 1) + ' '),  '') 
		+ LastName as UserName 
		,Active
From tUser (NOLOCK) 
Where SecurityGroupKey = @SecurityGroupKey and
isnull(OwnerCompanyKey, CompanyKey) = @CompanyKey
and Active = 1
Order By FirstName, LastName
GO
