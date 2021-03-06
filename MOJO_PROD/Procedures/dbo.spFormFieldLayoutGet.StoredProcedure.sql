USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFormFieldLayoutGet]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFormFieldLayoutGet]
  @FormLayoutKey int
 ,@CompanyKey int
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN
*/

 select fld.FieldName
       ,fld.DisplayOrder
       ,fd.Caption
       ,fd.Size
       ,fd.DisplayType
   from tFormLayoutDetail fld (nolock)
       LEFT OUTER JOIN tFieldDef fd (nolock) on fld.FieldName = fd.FieldName
  where fld.FormLayoutKey = @FormLayoutKey
    and fd.OwnerEntityKey = @CompanyKey
    and fd.AssociatedEntity = 'Forms'
  order by fld.DisplayOrder
  
     return 1
GO
