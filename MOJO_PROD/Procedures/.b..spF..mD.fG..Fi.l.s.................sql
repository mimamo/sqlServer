USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFormDefGetFields]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFormDefGetFields]
  @FieldDefKey int
AS --Encrypt
   SELECT *
    FROM  tFieldSet fs (nolock)
         ,tFieldDef fd (nolock)
         ,tFieldSetField ff (nolock)
    WHERE fs.OwnerEntityKey = @FieldDefKey
      and fs.AssociatedEntity = 'Forms'
      and fs.FieldSetKey = ff.FieldSetKey
      and ff.FieldDefKey = fd.FieldDefKey
    order by fd.Caption
 RETURN 1
GO
