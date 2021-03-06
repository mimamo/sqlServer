USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetByID]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetByID]

	(
		@UserID varchar(100)
	)

AS --Encrypt


Select * from tUser (NOLOCK)
inner join tCompany (NOLOCK) on tCompany.CompanyKey = ISNULL(tUser.OwnerCompanyKey, tUser.CompanyKey)
inner join tPreference (NOLOCK) on tPreference.CompanyKey = tCompany.CompanyKey
Where UserID = @UserID and tUser.Active = 1 and tCompany.Locked = 0
GO
