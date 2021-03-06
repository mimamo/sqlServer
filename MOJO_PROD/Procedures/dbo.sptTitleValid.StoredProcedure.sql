USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTitleValid]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTitleValid]
	 @CompanyKey int
	,@TitleNameOrID varchar(500) = NULL
AS  --Encrypt

/*
|| When       Who Rel      What
|| 09/19/2014 WDF 10.5.8.4 New
*/

DECLARE @TitleKey int

	
SELECT @TitleKey = TitleKey
  FROM tTitle (nolock)
 WHERE UPPER(TitleID) = UPPER(@TitleNameOrID) 
   AND CompanyKey = @CompanyKey

IF ISNULL(@TitleKey, 0) = 0
	SELECT @TitleKey = TitleKey
	  FROM tTitle (nolock)
	 WHERE UPPER(TitleName) = UPPER(@TitleNameOrID) 
	   AND CompanyKey = @CompanyKey

RETURN ISNULL(@TitleKey, 0)
GO
