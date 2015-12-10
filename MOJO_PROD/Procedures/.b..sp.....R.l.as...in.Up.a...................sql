USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSeedReleasePointUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSeedReleasePointUpdate]
 @SeedReleasePointKey int,
 @OrderNumber int,
 @Description varchar(100),
 @CompanyKey int
AS --Encrypt
 UPDATE
  tSeedReleasePoint
 SET
  OrderNumber = @OrderNumber,
  Description = @Description,
  CompanyKey = @CompanyKey
 WHERE
  SeedReleasePointKey = @SeedReleasePointKey 
 RETURN 1
GO
