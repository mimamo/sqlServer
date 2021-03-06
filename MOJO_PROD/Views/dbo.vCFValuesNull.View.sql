USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vCFValuesNull]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCFValuesNull]
AS

/*
|| When      Who Rel      What
|| 10/14/09  GHL 10.5.1.2 Added NOLOCK hints
|| 05/23/13  RLB 10.5.6.8 (174619) added formatting for multi checkbox data
|| 07/31/13  GHL 10.5.7.0 Cloned vCFValues and replaced '' by null
||                        Better performance than adding a FieldValueNull to vCFValues
*/

SELECT     
	tFieldValue.ObjectFieldSetKey AS CustomFieldKey,
	CASE  tFieldDef.DisplayType
		WHEN 10 THEN ',' + tFieldValue.FieldValue + ','
		ELSE tFieldValue.FieldValue
	END as FieldValue2,
	case when tFieldValue.FieldValue = '' then null else tFieldValue.FieldValue end as FieldValue,
	tFieldDef.OwnerEntityKey AS EntityKey, 
    tFieldDef.AssociatedEntity AS Entity, 
	tFieldDef.FieldName
FROM      
	tFieldDef (nolock)
	INNER JOIN tFieldValue (nolock) ON tFieldDef.FieldDefKey = tFieldValue.FieldDefKey
GO
