USE [MOJo_dev]
GO
/****** Object:  StoredProcedure [dbo].[spCF_UpdateFieldValue]    Script Date: 04/29/2016 14:51:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'spCF_UpdateFieldValue'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[spCF_UpdateFieldValue]
GO

CREATE PROCEDURE [dbo].[spCF_UpdateFieldValue] 
	 @CustomFieldKey int,
	 @FieldName varchar(75),
	 @FieldValue varchar(8000)
AS --Encrypt

/*******************************************************************************************************
*   MOJo_dev.dbo.spCF_UpdateFieldValue
*
*   Creator:	WMJ   
*   Date:		     
*   
*          
*   Notes: 
*
*   Usage:	set statistics io on

	execute MOJo_dev.dbo.spCF_UpdateFieldValue 
	

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
Declare @FieldValueKey as uniqueidentifier, 
	@FieldDefKey int
  
---------------------------------------------
-- create temp tables
---------------------------------------------
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------

Select @FieldDefKey = MIN(fd.FieldDefKey)
From mojo_Dev.dbo.tFieldDef fd (nolock)
inner join mojo_Dev.dbo.tFieldSetField fsf (nolock) 
	on fd.FieldDefKey = fsf.FieldDefKey
inner join mojo_Dev.dbo.tObjectFieldSet ofs (nolock) 
	on ofs.FieldSetKey = fsf.FieldSetKey
Where fd.FieldName = @FieldName and
	ofs.ObjectFieldSetKey = @CustomFieldKey
  
if ISNULL(@FieldDefKey, 0) = 0 
return -1

SELECT @FieldValueKey = FieldValueKey
FROM mojo_Dev.dbo.tFieldValue (NOLOCK)
WHERE FieldDefKey = @FieldDefKey 
	AND ObjectFieldSetKey = @CustomFieldKey
   
IF @FieldValueKey IS NULL
begin
 
	INSERT mojo_Dev.dbo.tFieldValue
	(
	   FieldValueKey,
	   FieldDefKey,
	   ObjectFieldSetKey,
	   FieldValue
	)
	select NEWID(),
	   @FieldDefKey,
	   @CustomFieldKey,
	   @FieldValue

end
ELSE
begin

  UPDATE mojo_Dev.dbo.tFieldValue
	SET FieldValue = @FieldValue
  WHERE FieldValueKey = @FieldValueKey 

end

RETURN 1
 
