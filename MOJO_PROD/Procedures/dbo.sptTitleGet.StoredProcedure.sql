USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleGet]
	@TitleKey int = 0,
	@TitleID varchar(50) = NULL,
	@CompanyKey int = NULL

AS --Encrypt

/*
  || When       Who Rel      What
  || 09/12/2014 WDF 10.5.8.4 New
*/

IF @TitleKey > 0
		SELECT tTitle.*
		FROM tTitle (NOLOCK)
		WHERE TitleKey = @TitleKey
ELSE
		SELECT tTitle.*
		FROM tTitle (NOLOCK)
		WHERE tTitle.CompanyKey = @CompanyKey 
		  AND tTitle.TitleID = @TitleID

RETURN 1
GO
