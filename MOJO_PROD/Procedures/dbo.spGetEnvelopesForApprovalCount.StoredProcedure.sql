USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetEnvelopesForApprovalCount]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetEnvelopesForApprovalCount]
	@UserKey int
 
AS --Encrypt

Declare @SheetCount int

 SELECT @SheetCount = Count(*)
 FROM tExpenseEnvelope en (NOLOCK),
   tUser u (NOLOCK)
 WHERE en.UserKey IN 
    (SELECT UserKey
    FROM tUser (NOLOCK)
    WHERE ExpenseApprover = @UserKey)
 AND  en.Status = 2
 AND  en.UserKey = u.UserKey

Return @SheetCount
GO
