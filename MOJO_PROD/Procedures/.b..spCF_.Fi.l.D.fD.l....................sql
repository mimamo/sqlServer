USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldDefDelete]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldDefDelete]
 @FieldDefKey int
AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/10/07 GHL 8411  Restricting now deletion if there is a valid value
  ||                    and the field definition is used in a field set
  || 1/8/13   GWG 10.5
  */
/*
 if exists(select tFieldValue.FieldDefKey 
			from tFieldValue (nolock)
				-- must be used in in a field set to be meaningful
				inner join tFieldSetField (nolock) on tFieldValue.FieldDefKey = tFieldSetField.FieldDefKey
			where tFieldValue.FieldDefKey = @FieldDefKey 
				-- must have a value
			and tFieldValue.FieldValue is not null
			)
  return -1
  */
  -- changing the restrict to prevent deletion if it is being used in any field set
 if exists(select 1 from tFieldSetField (nolock) where FieldDefKey = @FieldDefKey )
  return -1
  
 DELETE
 FROM tFieldValue
 WHERE
  FieldDefKey = @FieldDefKey
  
 DELETE
 FROM tFieldSetField
 WHERE
  FieldDefKey = @FieldDefKey
  
 DELETE
 FROM tFieldDef
 WHERE
  FieldDefKey = @FieldDefKey 
 RETURN 1
GO
