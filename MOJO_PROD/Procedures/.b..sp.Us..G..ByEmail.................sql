USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetByEmail]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetByEmail]
	@Email varchar(100),
	@CompanyKey int
	
AS --Encrypt

/*
|| When     Who Rel      What
|| 1/9/09   CRG 10.5.0.0 This SP was obsolete because tMessage didn't exist in the DB. I'm using it now for the Task Manager.
|| 11/3/09  RLB 10.5.1.3 (67211) added OwnerCompanyKey to put contacts links into the system
*/

	SELECT	*
	FROM	tUser (NOLOCK)
	WHERE	UPPER(Email) = UPPER(@Email)
	AND		(CompanyKey = @CompanyKey OR OwnerCompanyKey = @CompanyKey)
GO
