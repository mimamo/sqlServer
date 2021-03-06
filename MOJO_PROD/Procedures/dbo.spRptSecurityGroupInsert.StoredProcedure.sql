USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSecurityGroupInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptSecurityGroupInsert]
 (
  @ReportKey int,
  @MyKeys varchar(8000)  -- These are the SecurityGroupKeys
 )
AS --Encrypt

/*
|| When     Who Rel       What
|| 09/18/08 RTC 10.0.0.9  (35149) Verify security group still exists before attemting insert.
*/


declare @KeyChar varchar(100)
declare @KeyInt int
declare @Pos int

BEGIN TRAN

DELETE tRptSecurityGroup
WHERE  ReportKey = @ReportKey   
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
   
						--make sure it didn't get deleted prior to save
						if exists(select 1 from tSecurityGroup (nolock) where SecurityGroupKey = @KeyInt)
							begin
								INSERT tRptSecurityGroup (ReportKey, SecurityGroupKey)
								VALUES (@ReportKey, @KeyInt)
   
								IF @@ERROR <> 0
									BEGIN
										ROLLBACK TRAN
										RETURN -1
								END
							end
					END
				
				IF @Pos = 0 
					BREAK
				
				SELECT @MyKeys = SUBSTRING(@MyKeys, @Pos + 1, LEN(@MyKeys)) 
			END
	END
	
COMMIT TRAN
 
/* set nocount on */
return 1
GO
