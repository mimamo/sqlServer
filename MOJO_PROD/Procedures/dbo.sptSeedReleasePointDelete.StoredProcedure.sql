USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSeedReleasePointDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSeedReleasePointDelete]
 @SeedReleasePointKey int
AS --Encrypt
 DELETE
 FROM tSeedReleasePoint
 WHERE
  SeedReleasePointKey = @SeedReleasePointKey 
 RETURN 1
GO
