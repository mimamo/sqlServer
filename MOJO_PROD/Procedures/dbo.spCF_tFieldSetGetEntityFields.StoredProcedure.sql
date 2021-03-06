USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetGetEntityFields]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetGetEntityFields]
	@CompanyKey int,
	@AssociatedEntity varchar(50)
 
AS --Encrypt

/*
|| When      Who Rel     What
|| 05/21/10  MFT 10.530  Added QualifiedFieldName
|| 07/20/10  MFT 10.532  Added FieldSetName and Default value for ObjectFieldSetKey
*/

	select
		 fs.FieldSetKey
		,fs.OwnerEntityKey
		,fs.FieldSetName
		,fsf.DisplayOrder
		,fd.FieldDefKey
		,fd.FieldName
		,fd.DisplayType
		,fd.Caption
		,fd.Hint
		,fd.Size
		,fd.MinSize
		,fd.MaxSize
		,fd.TextRows
		,fd.ValueList
		,fd.Required
		,fd.OnlyAuthorEdit
		,'CF_' + @AssociatedEntity + '_' + fd.FieldName AS QualifiedFieldName
		,-1 AS ObjectFieldSetKey
	from tFieldSet fs (nolock) inner join tFieldSetField fsf (nolock) on fs.FieldSetKey = fsf.FieldSetKey
	inner join tFieldDef fd (nolock) on fsf.FieldDefKey = fd.FieldDefKey
	where fs.AssociatedEntity = @AssociatedEntity
	and fs.Active = 1
	and fd.Active = 1
	and fd.OwnerEntityKey = @CompanyKey
	order by 
		 fs.FieldSetKey
		,fsf.DisplayOrder
		
 return 1
GO
