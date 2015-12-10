USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateCC]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateCC]
	@CompanyKey int,
	@CCProcessor int,
	@CCLoginID varchar(100),
	@CCPartnerID varchar(50),
	@CCPassword varchar(100),
	@CCAltURL varchar(500),
	@ANTranKey varchar(100),
	@ANHashSecret varchar(100)

AS

 /*
  || When     Who Rel    What
  || 12/22/11 MFT 10.551 Added @CCPartnerID to support the new flash screen
  */
	UPDATE
		tPreference
	SET
		CCProcessor = @CCProcessor,
		CCLoginID = @CCLoginID,
		CCPartnerID = @CCPartnerID,
		CCPassword = @CCPassword,
		CCAltURL = @CCAltURL,
		ANTranKey = @ANTranKey,
		ANHashSecret = @ANHashSecret
	WHERE
		CompanyKey = @CompanyKey 

	RETURN 1
GO
