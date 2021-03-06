USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[xWKMJG_Billing_Exception]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gregory Houston / IronWare
-- Create date: 12.21.2011
-- Description:	To generate WKMJG exception report for Invoices
-- =============================================
CREATE PROCEDURE [dbo].[xWKMJG_Billing_Exception]
	
	@ENTITYKEY int,
	@DATEADDEDFROM smalldatetime,
	@DATEADDEDTO smalldatetime,
	@TRANSFERRED int,
	@INVOICENUMBER varchar(50),
	@PROJECTNUMBER varchar(50),
	@FUNCTIONCODE varchar(50),
	@INVOICEDATE smalldatetime
	
AS
BEGIN

SET NOCOUNT ON
SELECT * INTO #xWKMJG_Billing_Exception FROM xWKMJG_Billing_Exception_tmp WHERE 1 = 2

IF @TRANSFERRED = 0 BEGIN
INSERT INTO #xWKMJG_Billing_Exception
SELECT a.EntityKey, a.Action, a.DateAdded, a.DateTransferred, a.Error, A.TransferStatus,
		b.InvoiceNumber, b.ProjectNumber, b.SalesAccountNumber as FunctionCode, b.TotalLineAmount as Amount,
		b.InvoiceDate from intLogQueue a RIGHT OUTER JOIN intLogInvoiceDetail b ON
		a.LogKey = b.LogKey
		WHERE Entity = 'Invoice' AND a.Action = 'Posted' AND a.DateTransferred IS NULL END
		ELSE BEGIN
INSERT INTO #xWKMJG_Billing_Exception		
SELECT a.EntityKey, a.Action, a.DateAdded, a.DateTransferred, a.Error, A.TransferStatus,
		b.InvoiceNumber, b.ProjectNumber, b.SalesAccountNumber as FunctionCode, b.TotalLineAmount as Amount,
		b.InvoiceDate from intLogQueue a RIGHT OUTER JOIN intLogInvoiceDetail b ON
		a.LogKey = b.LogKey
		WHERE Entity = 'Invoice' AND a.Action = 'Posted' AND a.DateTransferred IS NOT NULL
		END
   
 IF @ENTITYKEY <> 0 BEGIN
 DELETE FROM #xWKMJG_Billing_Exception WHERE EntityKey <> @ENTITYKEY END
 
 IF @DATEADDEDFROM <> Cast('1/1/1900' as date) BEGIN
  DELETE FROM #xWKMJG_Billing_Exception WHERE DateAdded < @DATEADDEDFROM  END
  
IF @DATEADDEDTO <> Cast('1/1/1900' as date) BEGIN
  DELETE FROM #xWKMJG_Billing_Exception WHERE DateAdded > @DATEADDEDFROM  END
  
IF @PROJECTNUMBER <> '' BEGIN
  DELETE FROM #xWKMJG_Billing_Exception WHERE ProjectNumber <> @PROJECTNUMBER END 
  
IF @INVOICENUMBER <> '' BEGIN
  DELETE FROM #xWKMJG_Billing_Exception WHERE InvoiceNumber <> @INVOICENUMBER END 
  
IF @FUNCTIONCODE <> '' BEGIN
  DELETE FROM #xWKMJG_Billing_Exception WHERE FunctionCode <> @FUNCTIONCODE END  
  
IF @INVOICEDATE <> Cast('1/1/1900' as date) BEGIN
  DELETE FROM #xWKMJG_Billing_Exception WHERE InvoiceDate <> @INVOICEDATE END       
   
SELECT * FROM #xWKMJG_Billing_Exception
END
GO
