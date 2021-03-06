USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightUpdate]
 @RightKey int,
 @RightID varchar(35),
 @Description varchar(100),
 @RightGroup varchar(35)
AS --Encrypt
 UPDATE
  tRight
 SET
  RightID = @RightID,
  Description = @Description,
  RightGroup = @RightGroup
 WHERE
  RightKey = @RightKey 
 RETURN 1
GO
