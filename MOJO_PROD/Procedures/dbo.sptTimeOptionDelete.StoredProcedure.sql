USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeOptionDelete]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeOptionDelete]
 @CompanyKey int
AS --Encrypt
 DELETE
 FROM tTimeOption
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO
