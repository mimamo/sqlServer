USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightInsert]
 @RightID varchar(35),
 @Description varchar(100),
 @RightGroup varchar(35),
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tRight
  (
  RightID,
  Description,
  RightGroup
  )
 VALUES
  (
  @RightID,
  @Description,
  @RightGroup
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
