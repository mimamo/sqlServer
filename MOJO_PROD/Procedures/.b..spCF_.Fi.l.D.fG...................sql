USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldDefGet]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldDefGet]
 @FieldDefKey int
AS --Encrypt
  SELECT *
  FROM tFieldDef (NOLOCK)
  WHERE
   FieldDefKey = @FieldDefKey
 RETURN 1
GO
