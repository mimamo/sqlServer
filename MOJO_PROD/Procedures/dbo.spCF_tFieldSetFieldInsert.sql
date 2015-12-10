USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetFieldInsert]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetFieldInsert]
 @FieldSetKey int,
 @FieldDefKey int,
 @DisplayOrder int
AS --Encrypt
 INSERT tFieldSetField
  (
  FieldSetKey,
  FieldDefKey,
  DisplayOrder
  )
 VALUES
  (
  @FieldSetKey,
  @FieldDefKey,
  @DisplayOrder
  )
 RETURN 1
GO
