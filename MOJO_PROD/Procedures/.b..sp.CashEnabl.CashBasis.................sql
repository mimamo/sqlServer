USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashEnableCashBasis]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashEnableCashBasis]
	(
	@CompanyKey int 
	,@Customizations varchar(1000) -- NULL if we want to query tPreference
	)
AS

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
*/

	SET NOCOUNT ON
	
	-- Single point to control cash basis  
	DECLARE @TrackCash INT SELECT @TrackCash = 0
	
	IF @Customizations IS NULL
		SELECT @Customizations = Customizations
		FROM   tPreference (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		
	SELECT @Customizations = ISNULL(UPPER(@Customizations), '')	
	
	IF (CHARINDEX('TRACKCASH', @Customizations, 0) > 0)
		SELECT @TrackCash = 1

	RETURN @TrackCash
GO
