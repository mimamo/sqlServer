USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExpenseReportTypeSummary]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExpenseReportTypeSummary]
 (
  @ExpenseEnvelopeKey int
 )
AS --Encrypt
 SELECT 
  *
 FROM
  vExpenseReportExpenseTypeSummary (NOLOCK)
 WHERE
  ExpenseEnvelopeKey = @ExpenseEnvelopeKey
 ORDER BY
  Description
GO
