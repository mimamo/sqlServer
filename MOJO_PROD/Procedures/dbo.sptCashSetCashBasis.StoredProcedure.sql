USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashSetCashBasis]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashSetCashBasis]
	(
	@CompanyKey int
	,@Set int = 1	-- 1: Set or Enable, 0:Reset or disable
	)
	
AS --Encrypt
	SET NOCOUNT ON

	DECLARE @Customizations varchar(1000)
	
	SELECT @Customizations = Customizations
	FROM   tPreference (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	
	IF @Set = 1
	BEGIN
		-- Abort if we have the Cash basis flag set already
		IF (CHARINDEX('TRACKCASH', ISNULL(UPPER(@Customizations), ''), 0) > 0)
			RETURN 1
		
		IF ISNULL(@Customizations, '') = ''
			SELECT @Customizations = 'trackcash'
		ELSE
			SELECT @Customizations = @Customizations + '|trackcash'
	END
	
	IF @Set = 0
	BEGIN
		-- Abort if we DO NOT have the Cash basis flag set already
		IF (CHARINDEX('TRACKCASH', ISNULL(UPPER(@Customizations), ''), 0) = 0)
			RETURN 1

		select @Customizations = replace(@Customizations, '|trackcash', '')
		select @Customizations = replace(@Customizations, 'trackcash', '')
				
	END
	
	
	UPDATE tPreference SET Customizations = @Customizations WHERE CompanyKey = @CompanyKey
	
	RETURN 1
GO
