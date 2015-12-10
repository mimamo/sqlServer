USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetGetList]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetGetList]
 @CompanyKey int
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
  SELECT *
  FROM tTimeRateSheet (NOLOCK) 
  WHERE
   CompanyKey = @CompanyKey
  ORDER BY
   RateSheetName
 RETURN 1
GO
