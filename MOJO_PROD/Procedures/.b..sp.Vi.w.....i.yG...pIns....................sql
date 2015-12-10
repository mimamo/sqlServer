USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewSecurityGroupInsert]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewSecurityGroupInsert]
	@ViewKey int,
	@MyKeys varchar(8000), --Security Group Keys
	@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/23/06 CRG 8.35  Added CompanyKey so that other companys' Views don't get removed
*/

	DECLARE	@KeyChar varchar(100),
			@KeyInt int,
			@Pos int
	
	BEGIN TRAN
	
	EXEC sptViewSecurityGroupDelete @ViewKey, @CompanyKey

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	
	IF LEN(@MyKeys) > 0 
	BEGIN
		WHILE (1 = 1)
		BEGIN
			SELECT @Pos = CHARINDEX ('|', @MyKeys, 1) 
			IF @Pos = 0 
				SELECT @KeyChar = @MyKeys
			ELSE
				SELECT @KeyChar = LEFT(@MyKeys, @Pos -1)
			IF LEN(@KeyChar) > 0
			BEGIN
			SELECT @KeyInt = CONVERT(Int, @KeyChar)
			   
			INSERT	tViewSecurityGroup (ViewKey, SecurityGroupKey)
			VALUES	(@ViewKey, @KeyInt)
			   
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRAN
					RETURN -1
				END
			END
			IF @Pos = 0 
				BREAK
			  
			SELECT @MyKeys = SUBSTRING(@MyKeys, @Pos + 1, LEN(@MyKeys)) 
		END
	END

	COMMIT TRAN
	 
	RETURN 1
GO
