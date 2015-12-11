USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCFValues]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCFValues]
AS

/*
|| When      Who Rel      What
|| 10/14/09  GHL 10.5.1.2 Added NOLOCK hints
|| 05/23/13  RLB 10.5.6.8 (174619) added formatting for multi checkbox data
*/

SELECT     
	tFieldValue.ObjectFieldSetKey AS CustomFieldKey,
	CASE  tFieldDef.DisplayType
		WHEN 10 THEN ',' + tFieldValue.FieldValue + ','
		ELSE tFieldValue.FieldValue
	END as FieldValue2,
	tFieldValue.FieldValue,
	tFieldDef.OwnerEntityKey AS EntityKey, 
    tFieldDef.AssociatedEntity AS Entity, 
	tFieldDef.FieldName
FROM      
	tFieldDef (nolock)
	INNER JOIN tFieldValue (nolock) ON tFieldDef.FieldDefKey = tFieldValue.FieldDefKey
GO
