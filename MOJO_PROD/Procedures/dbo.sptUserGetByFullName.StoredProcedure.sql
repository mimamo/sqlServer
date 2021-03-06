USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetByFullName]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetByFullName]
	@CompanyKey int,
	@FullName varchar(100)
		
AS --Encrypt

/*
|| When     Who Rel      What
|| 04/29/09 MAS 10.5.0.0 Created
|| 09/29/09 MFT 10.5.1.1 Added OwnerCompanyKey to conditions
|| 09/30/09 MFT 10.5.1.1 Added condition to check for email compare first
|| 10/21/09 MFT 10.5.1.2 Added LTRIM/RTRIM to full name matching
|| 05/18/11 MAS 10.5.4.4 Try and match user on SystemID
*/

IF EXISTS(
	SELECT 1
	FROM tUser (nolock)
	WHERE
		UPPER(LTRIM(RTRIM(Email))) = UPPER(LTRIM(RTRIM(@FullName))) AND
		(
			CompanyKey = @CompanyKey OR
			OwnerCompanyKey = @CompanyKey
		)
	)
	
	SELECT	*
	FROM	tUser (nolock)
	WHERE
		UPPER(LTRIM(RTRIM(Email))) = UPPER(LTRIM(RTRIM(@FullName))) AND
		(
			CompanyKey = @CompanyKey OR
			OwnerCompanyKey = @CompanyKey
		)

ELSE
	IF EXISTS(
		SELECT	1
		FROM	tUser (nolock)
		WHERE
			UPPER(LTRIM(RTRIM(FirstName))) + ' ' + UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@FullName))) AND
			(
				CompanyKey = @CompanyKey OR
				OwnerCompanyKey = @CompanyKey
			)
		)	
		SELECT	*
		FROM	tUser (nolock)
		WHERE
			UPPER(LTRIM(RTRIM(FirstName))) + ' ' + UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@FullName))) AND
			(
				CompanyKey = @CompanyKey OR
				OwnerCompanyKey = @CompanyKey
			)
	ELSE
		SELECT	*
		FROM	tUser (nolock)
		WHERE
			UPPER(LTRIM(RTRIM(SystemID)))= UPPER(LTRIM(RTRIM(@FullName))) AND
			(
				CompanyKey = @CompanyKey OR
				OwnerCompanyKey = @CompanyKey
			)
GO
