USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightAssignedDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightAssignedDelete]
 @RightAssignedKey int
AS --Encrypt
 DELETE
 FROM tRightAssigned
 WHERE
  RightAssignedKey = @RightAssignedKey 
 RETURN 1
GO
