USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExpenseReportGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExpenseReportGet]
 (
  @ExpenseEnvelopeKey int
 )
AS --Encrypt

/*
|| When     Who Rel      What
|| 02/06/10 GWG 10.5.1.7 Added filter for TransferToKey
*/

Declare @NotifyEmail varchar(200)

Select @NotifyEmail = Email
From
	tUser u (nolock)
	Inner join tPreference p (nolock) on u.UserKey = p.NotifyExpenseReport
	inner join tExpenseEnvelope ee (nolock) on p.CompanyKey = ee.CompanyKey
Where
	ee.ExpenseEnvelopeKey = @ExpenseEnvelopeKey
	
 SELECT 
  vExpenseReport.*, @NotifyEmail as NotifyEmail 
 FROM 
  vExpenseReport (NOLOCK)
 WHERE
  ExpenseEnvelopeKey = @ExpenseEnvelopeKey and TransferToKey is null
 ORDER BY
  ExpenseDate, ItemName
GO
