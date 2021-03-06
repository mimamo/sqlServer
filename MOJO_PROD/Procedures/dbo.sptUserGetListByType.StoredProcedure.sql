USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetListByType]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetListByType]

	(
		@CompanyKey int,
		@Type smallint
	)

AS --Encrypt

IF @Type = 1
	Select
		u.FirstName + ' ' + u.LastName as UserName,
		u.Email,
		u.UserKey
	from tUser u (nolock)
	Where 
		CompanyKey = @CompanyKey and
		Active = 1
	Order By FirstName
else
	Select
		c.CompanyName + ' \ ' + u.FirstName + ' ' + u.LastName as UserName,
		u.Email,
		u.UserKey
	from tUser u (nolock)
		inner join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
	Where 
		u.OwnerCompanyKey = @CompanyKey and
		u.Active = 1 and
		c.Active = 1
	Order By CompanyName, FirstName
GO
