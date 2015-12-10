USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldDefGetListModified]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldDefGetListModified]
 @OwnerEntityKey int,
 @AssociatedEntity varchar(50),
 @Active tinyint = 1

AS --Encrypt

/*
|| When      Who Rel     What
|| 04/15/15  WDF 10.591  (250962) Added for Kohls requirements

*/

Create Table #ModifiedCFFields
   (FieldName varchar(75)
   ,Caption varchar(75)
   ,DisplayType varchar(20))


	INSERT INTO #ModifiedCFFields
	SELECT CASE fd.DisplayType
	         WHEN 7 THEN 
	                 CASE ISNUMERIC(RIGHT(fd.FieldName, 1))
	                     WHEN 0 THEN fd.FieldName
	                     ELSE LEFT(fd.FieldName, LEN(fd.FieldName) - 1)
	                  END
				ELSE fd.FieldName
			END as FieldName
		   ,CASE fd.DisplayType
	         WHEN 7 THEN 
	                 CASE ISNUMERIC(RIGHT(fd.Caption, 1))
	                     WHEN 0 THEN fd.Caption
	                     ELSE LEFT(fd.Caption, LEN(fd.Caption) - 1)
	                  END
				ELSE fd.Caption
			END as Caption
		   ,CASE fd.DisplayType
				WHEN 1 THEN 'Numeric'
				WHEN 2 THEN 'Currency'
				WHEN 3 THEN 'Date'
				WHEN 4 THEN 'Text'
				WHEN 5 THEN 'Text Area'
				WHEN 6 THEN 'Radio Button'
				WHEN 7 THEN 'Dropdown'
				--WHEN 8 THEN 'Separator Text'
				WHEN 9 THEN 'Single Checkbox'
				WHEN 10 THEN 'Multiple Checkbox'
				--WHEN 11 THEN 'Tab'
				ELSE 'Text'
			 End as DisplayType
	 FROM tFieldDef fd (NOLOCK)
	WHERE fd.OwnerEntityKey = @OwnerEntityKey 
	  AND fd.AssociatedEntity = @AssociatedEntity
	  AND fd.Active = @Active
	  AND fd.DisplayType <> 8
	  AND fd.DisplayType <> 11

	SELECT * from #ModifiedCFFields GROUP BY FieldName, Caption, DisplayType ORDER BY FieldName


	RETURN 1
GO
