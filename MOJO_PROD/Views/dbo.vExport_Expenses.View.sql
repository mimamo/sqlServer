USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vExport_Expenses]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vExport_Expenses]

/*
|| When     Who Rel   What
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem
*/

AS
SELECT 
	ee.CompanyKey, 
	ee.ExpenseEnvelopeKey,
	u.SystemID, 
	u.FirstName,
	u.LastName,
	ee.EnvelopeNumber, 
	ee.StartDate, 
	ee.EndDate, 
	ee.Status, 
	ee.DateCreated, 
	ee.DateApproved, 
	er.ExpenseDate, 
	i.ItemID AS ExpenseID, 
	(select AccountNumber from tGLAccount gl (NOLOCK) Where i.ExpenseAccountKey = gl.GLAccountKey) as ExpenseGLAccount,
	(select sum(ActualCost) from tExpenseReceipt ers (NOLOCK) where ers.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey) as EnvelopeTotal,
	er.ActualQty, 
	er.ActualUnitCost, 
	er.ActualCost, 
	ISNULL(ee.Downloaded, 0) as Downloaded, 
	er.Description, 
	er.Comments, 
	u.CompanyKey AS UserCompanyKey
from
	tExpenseReceipt er (NOLOCK),
	tExpenseEnvelope ee (NOLOCK),
	tItem i (NOLOCK),
	tUser u (NOLOCK)

WHERE 
	ee.Status = 4 and
	er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey and
	ee.UserKey = u.UserKey and
	er.ItemKey = i.ItemKey
GO
