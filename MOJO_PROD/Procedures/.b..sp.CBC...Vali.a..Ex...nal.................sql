USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBCodeValidateExternal]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBCodeValidateExternal]
	(
		@CompanyKey INT
		,@CBCode VARCHAR(400)
	)
AS 
	SET NOCOUNT ON
	
	DECLARE @ValidatedExternally INT
	SELECT @ValidatedExternally = 0

	DECLARE @LDG_ACCNT_NO DECIMAL(7, 0)
	        ,@LDG_EXP_TYPE_CD FLOAT
	        ,@LDG_RSLT_CD DECIMAL(18, 0)
	        
	-- In Creative Manager accounts may be varchar
	-- Make sure that they can be converted to DECIMAL(7,0)
	IF ISNUMERIC(@CBCode) = 0
	BEGIN
		UPDATE tCBCode
		SET    Active = @ValidatedExternally
		WHERE  CBCode = @CBCode
		AND    CompanyKey = @CompanyKey
		
		RETURN @ValidatedExternally	
	END

	-- Protect from Overflow
	IF LEN(@CBCode) > 7
	BEGIN
		UPDATE tCBCode
		SET    Active = @ValidatedExternally
		WHERE  CBCode = @CBCode
		AND    CompanyKey = @CompanyKey
		
		RETURN @ValidatedExternally	
	END
	        
	-- Convert to data type used in Pam's table
	SELECT @LDG_ACCNT_NO = CAST(@CBCode AS DECIMAL(7,0))
	
	-- Expense Type 742 for prefix 4140 or All Charge Codes
	-- Expense Type 731 for prefix 4141
	
	SELECT @LDG_EXP_TYPE_CD = 742

	-- Lookup in Pam's table in master database
	SELECT @LDG_RSLT_CD = LDG_RSLT_CD
	FROM   master..vrf_acct (NOLOCK)
	WHERE  LDG_ACCNT_NO = @LDG_ACCNT_NO
	AND    LDG_EXP_TYPE_CD = @LDG_EXP_TYPE_CD
		
	-- If found in the table and the code is 0 then it is valid	
	IF @LDG_RSLT_CD IS NOT NULL AND @LDG_RSLT_CD = 0
		SELECT @ValidatedExternally = 1  

				
	UPDATE tCBCode
	SET    Active = @ValidatedExternally
	WHERE  CBCode = @CBCode
	AND    CompanyKey = @CompanyKey
				
	RETURN @ValidatedExternally
GO
