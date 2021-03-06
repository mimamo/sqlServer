USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldDefGetList]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldDefGetList]
 @OwnerEntityKey int,
 @AssociatedEntity varchar(50),
 @Active tinyint = null

AS --Encrypt

/*
|| When      Who Rel     What
|| 09/13/12  RLB 10.560  (153954) Added Active Option
|| 10/01/13  RLB 10.573  (187733) Added DisplayTypeName and others for enhancement
|| 10/03/13  RLB 10.573  (187735) Added a new display Type Tab
*/

If @Active is null
	SELECT 
		tFieldDef.*, 
			CASE tFieldDef.DisplayType
				WHEN 1 THEN 'Numeric'
				WHEN 2 THEN 'Currency'
				WHEN 3 THEN 'Date'
				WHEN 4 THEN 'Text'
				WHEN 5 THEN 'Text Area'
				WHEN 6 THEN 'Radio Button'
				WHEN 7 THEN 'Dropdown'
				WHEN 8 THEN 'Separator Text'
				WHEN 9 THEN 'Single Checkbox'
				WHEN 10 THEN 'Multiple Checkbox'
				WHEN 11 THEN 'Tab'
			END as DisplayTypeName,
			CASE tFieldDef.DisplayType
				WHEN 8 THEN '---' + tFieldDef.FieldName + '---'
				ELSE tFieldDef.FieldName
			END as FieldDisplayName,
			CASE tFieldDef.Active
				WHEN 1 THEN 'Yes'
				ELSE 'No'
			END as IsActive,
			CASE tFieldDef.Required
				WHEN 1 THEN 'Yes'
				ELSE 'No'
			END as IsRequired
			
	FROM 
		tFieldDef (NOLOCK)
	WHERE
		OwnerEntityKey = @OwnerEntityKey 
		AND AssociatedEntity = @AssociatedEntity
	ORDER BY
		FieldName

else
	SELECT 
		tFieldDef.*, 
			CASE tFieldDef.DisplayType
				WHEN 1 THEN 'Numeric'
				WHEN 2 THEN 'Currency'
				WHEN 3 THEN 'Date'
				WHEN 4 THEN 'Text'
				WHEN 5 THEN 'Text Area'
				WHEN 6 THEN 'Radio Button'
				WHEN 7 THEN 'Dropdown'
				WHEN 8 THEN 'Separator Text'
				WHEN 9 THEN 'Single Checkbox'
				WHEN 10 THEN 'Multiple Checkbox'
			END as DisplayTypeName,
			CASE tFieldDef.DisplayType
				WHEN 8 THEN '---' + tFieldDef.FieldName + '---'
				ELSE tFieldDef.FieldName
			END as FieldDisplayName,
			CASE tFieldDef.Active
				WHEN 1 THEN 'Yes'
				ELSE 'No'
			END as IsActive,
			CASE tFieldDef.Required
				WHEN 1 THEN 'Yes'
				ELSE 'No'
			END as IsRequired
	FROM 
		tFieldDef (NOLOCK)
	WHERE
		OwnerEntityKey = @OwnerEntityKey 
		AND AssociatedEntity = @AssociatedEntity
		AND Active = @Active
	ORDER BY
		FieldName


	RETURN 1
GO
