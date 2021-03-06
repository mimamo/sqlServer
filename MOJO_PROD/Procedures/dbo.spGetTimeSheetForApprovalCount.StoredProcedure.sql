USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetTimeSheetForApprovalCount]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetTimeSheetForApprovalCount]
 @UserKey int
 
AS --Encrypt

Declare @SheetCount int

 SELECT @SheetCount = Count(*)
 FROM tTimeSheet ts (NOLOCK),
   tUser u (NOLOCK)
 WHERE ts.UserKey IN 
    (SELECT UserKey
    FROM tUser (NOLOCK)
    WHERE TimeApprover = @UserKey)
 AND  ts.Status = 2
 AND  ts.UserKey = u.UserKey

Return @SheetCount
GO
