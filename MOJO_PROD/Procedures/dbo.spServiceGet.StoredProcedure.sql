USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spServiceGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spServiceGet]
 @CompanyKey int
AS --Encrypt
  SELECT *
  FROM tService (nolock)
  WHERE
   CompanyKey = @CompanyKey
 RETURN 1
GO
