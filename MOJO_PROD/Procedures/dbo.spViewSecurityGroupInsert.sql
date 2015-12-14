USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spViewSecurityGroupInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spViewSecurityGroupInsert]
 (
  @ViewKey int,
  @MyKeys varchar(8000)  -- These are the SecurityGroupKeys
 )
AS --Encrypt
declare @KeyChar varchar(100)
declare @KeyInt int
declare @Pos int
BEGIN TRAN
DELETE tViewSecurityGroup
WHERE  ViewKey = @ViewKey   
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
   
   INSERT tViewSecurityGroup (ViewKey, SecurityGroupKey)
   VALUES (@ViewKey, @KeyInt)
   
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
 
 /* set nocount on */
 return 1
GO
