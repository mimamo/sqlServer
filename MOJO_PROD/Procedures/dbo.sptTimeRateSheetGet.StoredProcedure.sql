USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeRateSheetGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeRateSheetGet]
 @TimeRateSheetKey int
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
  SELECT *
  FROM tTimeRateSheet (NOLOCK) 
  WHERE
   TimeRateSheetKey = @TimeRateSheetKey
 RETURN 1
GO
