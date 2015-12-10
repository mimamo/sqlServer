USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10587]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10587]

AS
	SET NOCOUNT ON

	-- 232052 - Set customizations to allow only current clients to see legacy items. 
	DECLARE @CompanyKey INT
	DECLARE @Custom varchar(1000)
	DECLARE @Legacy varchar(1000)
	
	SELECT @CompanyKey = -1
	SELECT @Legacy = 'legacyassigntypes|legacymastertasks|legacyskills|legacyroles|legacyclasses|legacykeypeople|legacyforms|legacyexchange|legacyfields|legacyreports|legacymedia|legacytasksum|legacysecurity'

	WHILE (1=1)
	BEGIN
		SELECT @CompanyKey = MIN(CompanyKey)
		  FROM tPreference
		 WHERE CompanyKey > @CompanyKey

		IF @CompanyKey IS NULL
			BREAK

		SELECT @Custom = Customizations
		  FROM tPreference
		 WHERE CompanyKey = @CompanyKey
		
		IF LEN(@Custom) > 0
			SET @Custom = @Custom + '|' + @Legacy
		ELSE
			SET @Custom = @Legacy
		
		UPDATE tPreference
		   SET Customizations = @Custom
		 WHERE CompanyKey = @CompanyKey
	END

	RETURN 1
GO
