USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightDelete]
 @RightKey int
AS --Encrypt
 DELETE
 FROM tRight
 WHERE
  RightKey = @RightKey 
 RETURN 1
GO
