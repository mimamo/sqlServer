USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportReadContacts]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spImportReadContacts]
 (
 @ContactKeys varchar(8000)
 )
AS --Encrypt
declare @KeyChar varchar(100)
declare @KeyInt int
declare @Pos int
declare @NewFlag int
/* Must be done in VB or ASP Code 
CREATE TABLE #tMyKeys(UserKey int Null, NewFlag int Null )
*/
TRUNCATE TABLE #tMyKeys
IF LEN(@ContactKeys) > 0 
BEGIN
 WHILE (1 = 1)
 BEGIN
  SELECT @Pos = CHARINDEX ('|', @ContactKeys, 1) 
  IF @Pos = 0 
   SELECT @KeyChar = @ContactKeys
  ELSE
   SELECT @KeyChar = LEFT(@ContactKeys, @Pos -1)
  IF LEN(@KeyChar) > 0
  BEGIN
   SELECT @KeyInt = CONVERT(Int, @KeyChar)
   IF @KeyInt > 0
    SELECT @NewFlag = 0
   ELSE
    SELECT @NewFlag = 1
   INSERT #tMyKeys (UserKey, NewFlag)
   SELECT ABS(@KeyInt), @NewFlag
   
  END
  IF @Pos = 0 
   BREAK
  
  SELECT @ContactKeys = SUBSTRING(@ContactKeys, @Pos + 1, LEN(@ContactKeys)) 
   
    
 END
END
 UPDATE #tMyKeys
 SET    #tMyKeys.LastName = u.LastName
       ,#tMyKeys.FirstName = u.FirstName
       ,#tMyKeys.Phone1 = u.Phone1
       ,#tMyKeys.CompanyName = c.CompanyName
 FROM    tUser    u (NOLOCK)
        ,tCompany c (NOLOCK)
 WHERE   #tMyKeys.UserKey    = u.UserKey
 AND     u.CompanyKey = c.CompanyKey
 /* set nocount on */
 return 1
GO
