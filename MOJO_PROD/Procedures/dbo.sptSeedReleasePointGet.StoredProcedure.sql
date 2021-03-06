USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSeedReleasePointGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSeedReleasePointGet]
 @SeedReleasePointKey int
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
 IF @SeedReleasePointKey IS NULL
  SELECT *
  FROM  tSeedReleasePoint (NOLOCK) 
 ELSE
  SELECT *
  FROM tSeedReleasePoint (NOLOCK) 
  WHERE
   SeedReleasePointKey = @SeedReleasePointKey
 RETURN 1
GO
