USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceValid]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceValid]
	 @CompanyKey int
	,@ServiceNameOrCode varchar(100) = NULL
AS  --Encrypt

/*
  || When       Who Rel      What
  || 10/26/2009 RLB 10.5.1.2 Added valid date service and pull ServiceKey
  || 06/28/2012 MFT 10.5.5.7 Added secondary match for Description
*/  

DECLARE @ServiceKey int

	
SELECT @ServiceKey = ServiceKey
FROM tService (nolock)
WHERE
	UPPER(ServiceCode) = UPPER(@ServiceNameOrCode) AND
	CompanyKey = @CompanyKey

IF ISNULL(@ServiceKey, 0) = 0
	SELECT @ServiceKey = ServiceKey
	FROM tService (nolock)
	WHERE
		UPPER(Description) = UPPER(@ServiceNameOrCode) AND
		CompanyKey = @CompanyKey

RETURN ISNULL(@ServiceKey, 0)
GO
