USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadGetByFullName]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadGetByFullName]
	 @FullName varchar(100),
	 @CompanyKey int
AS 

/*
|| When		Who	Rel	What
|| 09/15/2009	MFT	10.510	Created
|| 09/30/2009	MFT	10.511	Added condition to check for email compare first		
*/

IF EXISTS(
	SELECT 1
	FROM tUserLead (nolock)
	WHERE
		UPPER(Email) = UPPER(@FullName) AND
		CompanyKey = @CompanyKey)
	
	SELECT * 
	FROM tUserLead (nolock)
	WHERE
		UPPER(Email) = UPPER(@FullName) AND
		CompanyKey = @CompanyKey
	
ELSE
	
	SELECT * 
	FROM tUserLead (nolock)
	WHERE
		UPPER(FirstName) + ' ' + UPPER(LastName) = UPPER(@FullName) AND
		CompanyKey = @CompanyKey
	
RETURN 1
GO
