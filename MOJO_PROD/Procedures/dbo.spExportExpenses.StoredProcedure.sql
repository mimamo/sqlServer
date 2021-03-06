USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spExportExpenses]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spExportExpenses]
 (
  @CompanyKey int,
  @Status int,
  @StartDate smalldatetime,
  @EndDate smalldatetime,
  @IncludeDownloaded tinyint,
  @MarkDownloaded tinyint
 )
AS --Encrypt

/*
|| When     Who Rel   What
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem
*/

IF @StartDate IS NULL
    SELECT @StartDate = '1/1/1990'
 
 
IF @EndDate IS NULL
    SELECT @EndDate = GETDATE()
    SELECT 
        tUser.SystemID, 
        tUser.CompanyKey,
        tExpenseReceipt.ExpenseReceiptKey AS TicketNumber, 
        tExpenseReceipt.ExpenseDate, 
        tItem.ItemID AS ExpenseID, 
        tCompany.CustomerID, 
        tExpenseReceipt.Description, 
        tExpenseReceipt.Comments, 
        tExpenseReceipt.ActualQty, 
        tExpenseReceipt.ActualUnitCost, 
        tExpenseReceipt.ActualCost
    FROM 
        tItem (NOLOCK) 
            INNER JOIN tExpenseEnvelope (NOLOCK) 
	        INNER JOIN tExpenseReceipt (NOLOCK) ON tExpenseEnvelope.ExpenseEnvelopeKey = tExpenseReceipt.ExpenseEnvelopeKey
            INNER JOIN tUser (NOLOCK) ON tExpenseEnvelope.UserKey = tUser.UserKey 
                    ON tItem.ItemKey = tExpenseReceipt.ItemKey
            LEFT OUTER JOIN tCompany (NOLOCK) RIGHT OUTER JOIN tProject (NOLOCK) ON tCompany.CompanyKey = tProject.ClientKey 
                    ON tExpenseReceipt.ProjectKey = tProject.ProjectKey
    WHERE 
        tExpenseEnvelope.Status >= @Status
        AND tExpenseReceipt.Downloaded <= @IncludeDownloaded 
        AND tExpenseEnvelope.CompanyKey = @CompanyKey 
        AND tExpenseReceipt.ExpenseDate >= @StartDate 
        AND tExpenseReceipt.ExpenseDate <= @EndDate
GO
