USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetFieldDelete]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetFieldDelete]
 @FieldSetKey int
AS --Encrypt
 DELETE
 FROM tFieldSetField
 WHERE
  FieldSetKey = @FieldSetKey 
 RETURN 1
GO
