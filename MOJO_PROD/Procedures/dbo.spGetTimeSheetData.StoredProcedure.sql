USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetTimeSheetData]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetTimeSheetData]
 @TimeSheetKey int
 
AS --Encrypt
 SELECT Email, StartDate, EndDate
 FROM tUser u (nolock),
   tTimeSheet ts
 WHERE ts.TimeSheetKey = @TimeSheetKey
 AND  ts.UserKey = u.UserKey
 
 RETURN 1
GO
