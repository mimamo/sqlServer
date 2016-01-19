use DENVERAPP
go

CREATE FUNCTION dbo.SplitString (@StringToSplit VARCHAR(MAX))
RETURNS

 @returnList TABLE ([Name] [nvarchar] (500))
 
AS

/*******************************************************************************************************
*   DENVERAPP.dbo.SplitString 
*
*   Creator:	Michelle Morales
*   Date:		01/13/2015  
*   
*
*   Notes:     SELECT * FROM DENVERAPP.dbo.SplitString('91|12|65|78|56|789')
*                  
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX('|', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX('|', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
 
END