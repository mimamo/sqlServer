USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetDeleteTime]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTimeSheetDeleteTime]
 @TimeSheetKey int

AS --Encrypt
 
 DELETE  tTime
 WHERE   TimeSheetKey = @TimeSheetKey
  
 RETURN 1
GO
