USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSeedReleasePointInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSeedReleasePointInsert]
 @OrderNumber int,
 @Description varchar(100),
 @CompanyKey int,
 @oIdentity INT OUTPUT
AS --Encrypt
 INSERT tSeedReleasePoint
  (
  OrderNumber,
  Description,
  CompanyKey
  )
 VALUES
  (
  @OrderNumber,
  @Description,
  @CompanyKey
  )
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
