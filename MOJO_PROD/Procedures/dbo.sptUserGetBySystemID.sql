USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetBySystemID]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetBySystemID]

	(
		@SystemID varchar(500)
	)

AS --Encrypt


Select top 1 UserKey, ISNULL(OwnerCompanyKey, CompanyKey) as CompanyKey from tUser (NOLOCK)
Where SystemID = @SystemID and tUser.Active = 1
GO
