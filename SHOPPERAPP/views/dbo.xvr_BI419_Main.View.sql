USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xvr_BI419_Main]    Script Date: 12/21/2015 16:12:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT *
--FROM rptRuntime

CREATE VIEW [dbo].[xvr_BI419_Main]
as
SELECT DISTINCT GLTran.Module as 'GLTranModule'
, GLTran.ProjectID as 'GLTranProjectID'
, GLTran.BatNbr as 'GLTranBatNbr'
, GLTran.RefNbr as 'GLTranRefNbr'
, Batch.Module as 'BatchModule'
, PJINVHDR.invoice_date as 'Invoice_Date'
, PJINVHDR.gross_amt as 'InvoiceAmount'
, PJINVHDR.invoice_num as 'InvoiceNum'
, PJINVDET.linenbr as 'LineNum'
, PJINVDET.li_type as 'LineItemType'
, PJPROJ.pm_id01 as 'CustCode'
, Customer.[Name] as 'CustName'
, PJPROJ.project_desc as 'ProjuctDesc'
, PJPROJ.pm_id02 as 'ProductCode'
, pjcode.code_value_desc as 'Product'
 FROM  GLTran INNER JOIN Batch 
	ON GLTran.BatNbr = Batch.BatNbr INNER JOIN PJINVHDR 
	ON GLTran.BatNbr = PJINVHDR.batch_id 
	AND GLTran.RefNbr = PJINVHDR.invoice_num INNER JOIN PJINVDET 
	ON PJINVHDR.draft_num = PJINVDET.draft_num INNER JOIN PJPROJ 
	ON PJINVDET.project = PJPROJ.project LEFT OUTER JOIN pjcode 
	ON PJPROJ.pm_id02 = pjcode.code_value 
	AND pjcode.code_type = 'BCYC' LEFT OUTER JOIN Customer 
	ON PJPROJ.pm_id01 = Customer.CustId
 WHERE  GLTran.Module = 'BI' 
	AND GLTran.JrnlType <> 'REV' 
	AND Batch.Module = 'BI'
GO
