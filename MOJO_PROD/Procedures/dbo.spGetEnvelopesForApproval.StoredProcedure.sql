USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetEnvelopesForApproval]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetEnvelopesForApproval]
 @UserKey int
 
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/

Declare @NotifyEmail varchar(200), @CompanyKey int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (nolock) Where UserKey = @UserKey

Select @NotifyEmail = Email
From
	tUser u (nolock)
	Inner join tPreference p (nolock) on u.UserKey = p.NotifyExpenseReport
Where
	p.CompanyKey = @CompanyKey
	
 SELECT ee.ExpenseEnvelopeKey, ee.EnvelopeNumber, ee.StartDate, ee.EndDate,
   SUM(er.ActualCost) AS TotalCost, ee.Status, u.Email, u.FirstName, u.LastName, 
   ee.ApprovalComments, @NotifyEmail as NotifyEmail
 FROM tExpenseEnvelope ee (NOLOCK)
   INNER JOIN tExpenseReceipt er (NOLOCK) ON ee.ExpenseEnvelopeKey = er.ExpenseEnvelopeKey
   INNER JOIN tUser u (NOLOCK) ON ee.UserKey = u.UserKey
 WHERE ee.UserKey IN 
    (SELECT UserKey
    FROM tUser (NOLOCK)
    WHERE ExpenseApprover = @UserKey)
 AND  ee.Status = 2
 GROUP BY ee.ExpenseEnvelopeKey, ee.EnvelopeNumber, u.Email, ee.Status, ee.StartDate, ee.EndDate,
   u.FirstName, u.LastName, ee.ApprovalComments
 ORDER BY ee.EnvelopeNumber
GO
