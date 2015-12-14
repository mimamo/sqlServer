USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMailingInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMailingInsert]
	(
	@CompanyKey INT,
	@MailingName VARCHAR(500),
	@MailingID VARCHAR(100),
	@MailingStart VARCHAR(50)
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Initial Release
*/

	IF NOT EXISTS(SELECT 1 FROM tMailing WHERE CompanyKey = @CompanyKey AND MailingID = @MailingID )
	  BEGIN
		INSERT INTO tMailing (CompanyKey, MailingName, MailingID, DateAdded)
		VALUES (@CompanyKey, @MailingName, @MailingID, @MailingStart)
	  END
GO
