USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRightGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRightGet]
 @RightKey int
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
 IF @RightKey IS NULL
  SELECT *
        ,1 AS Allowed  -- To make compatible with spSecurityGetRights 
  FROM  tRight (NOLOCK) 
 ELSE
  SELECT *
        ,1 AS Allowed
  FROM tRight (NOLOCK) 
  WHERE
   RightKey = @RightKey
 RETURN 1
GO
