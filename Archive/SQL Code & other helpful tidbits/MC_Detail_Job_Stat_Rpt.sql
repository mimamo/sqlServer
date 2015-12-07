--- works but does not have the aps data
select
t.project as 'Job'
, p.project_desc as 'Job Desc'
, p.customer as 'Client ID'
, t.pjt_entity as 'Function Code'
, a.InvoiceNbr as 'Vendor Invoice Number'
, a.InvoiceDate as 'Vendor Invoice Date'
, a.ClientInvNbr as 'Client Invoice Number'
, ar.docdate as 'Client Invoice Date'
, a.Amount as 'Cost'
, inv.gross_amt as 'Invoice Amount'
, v.VendId as 'Vendor ID'
, v.Name as 'Vendor Name'
, c.RefNbr as 'Check Number'
, c.DocDate as 'Check Date'
, c.CuryOrigDocAmt as 'Check Amount'
, c.DocType as 'DocType'
 from PJPROJ p, AP03630MC_Wrk c, PJPENT t LEFT OUTER JOIN  
 xvr_PA005_ActCom a(nolock) ON (t.Project = a.project AND t.pjt_entity = a.Task)
 LEFT OUTER JOIN Vendor v ON a.VendorID = v.VendId LEFT OUTER JOIN ARDoc ar ON (a.Project = ar.ProjectID and a.ClientInvNbr = ar.RefNbr)
 LEFT OUTER JOIN PJINVHDR inv ON a.ClientInvNbr = inv.invoice_num
 where t.project = p.project
 AND (c.APDocVO_InvcNbr = a.InvoiceNbr AND c.VendId = v.VendId)
 AND (p.customer between '1MBAT' AND '1MOLBD' OR p.customer IN ('1ACGB','1CBC00','1CBCIN','2CBCSW','2MCSWS','2CBCCO','2CBCSC'))
 AND ar.docdate between '1/1/2010' and '12/31/2012'
 
--begin of test 
 select cust.CustID, p.project, p.project_desc 
 FROM
 (select CustId, Name from Customer 
	where (CustId between '1MBAT' AND '1MOLBD' OR CustId IN ('1ACGB','1CBC00','1CBCIN','2CBCSW','2MCSWS','2CBCCO','2CBCSC')))cust 
LEFT OUTER JOIN 
	(select t.project, p.project_desc, p.pm_id01, t.pjt_entity
		from PJPROJ p, PJPENT t where t.project = p.project group by t.project, p.project_desc, p.pm_id01, t.pjt_entity)p ON cust.CustId = p.pm_id01


 -- test new query might have APS Data
select ltrim(rtrim(cust.CustID)) as 'Client ID'
, ltrim(rtrim(cust.Name)) as 'Customer Name'
, ltrim(rtrim(p.project)) as 'Job'
, ltrim(rtrim(p.project_desc)) as 'Job Description'
, ltrim(rtrim(p.pjt_entity)) as 'Function Code'
, ltrim(rtrim(v.VendId)) as 'Vendor ID'
, ltrim(rtrim(v.Name)) as 'Vendor Name'
, ltrim(rtrim(p.InvoiceNbr)) as 'Vendor Invoice Number'
, ltrim(rtrim(p.InvoiceDate)) as 'Vendor Invoice Date'
, ltrim(rtrim(p.ClientInvNbr)) as 'Client Invoice Number'
, ltrim(rtrim(inv.invoice_date)) as 'Client Invoice Date'
, ltrim(rtrim(p.Amount)) as 'Cost'
, ltrim(rtrim(inv.gross_amt)) as 'Invoice Amount'
, ltrim(rtrim(p.RefNbr)) as 'Check Number'
, ltrim(rtrim(p.DocDate)) as 'Check Date'
, ltrim(rtrim(p.CuryOrigDocAmt)) as 'Check Amount'
, ltrim(rtrim(p.DocType)) as 'DocType'
 FROM
 (select CustId, Name from Customer 
	where (CustId between '1MBAT' AND '1MOLBD' OR CustId IN ('1ACGB','1CBC00','1CBCIN','2CBCSW','2MCSWS','2CBCCO','2CBCSC')))cust 
LEFT OUTER JOIN 
	(select p.project, p.project_desc, p.pm_id01, p.pjt_entity, a.InvoiceNbr, a.RefNbr, a.DocDate , a.CuryOrigDocAmt, a.DocType 
		, a.InvoiceDate, a.ClientInvNbr, a.Amount, a.VendorID
 from
 (select t.project, p.project_desc, p.pm_id01, t.pjt_entity
		from PJPROJ p, PJPENT t where t.project = p.project group by t.project, p.project_desc, p.pm_id01, t.pjt_entity)p 
LEFT OUTER JOIN 
(select
 a.Project, a.InvoiceDate, a.ClientInvNbr, a.Amount, a.VendorID, a.InvoiceNbr, c.RefNbr, c.DocDate , c.CuryOrigDocAmt, c.DocType, a.Task 
from
 xvr_PA005_ActCom a(nolock) LEFT OUTER JOIN AP03630MC_Wrk c ON (a.InvoiceNbr = c.APDocVO_InvcNbr AND a.VendorID = c.VendId)
 where (a.InvoiceNbr <> '' AND a.VendorID <> ''))a
 ON (p.Project = a.project AND p.pjt_entity = a.Task))p ON cust.CustId = p.pm_id01
 LEFT OUTER JOIN Vendor v ON p.VendorID = v.VendId 
 LEFT OUTER JOIN PJINVHDR inv ON p.ClientInvNbr = inv.invoice_num
 where inv.invoice_date between '1/1/2010' and '12/31/2011'
 order by cust.CustId, p.project 
 
 -- make sure there are no null invoice numbers
 select
 a.Project, a.InvoiceDate, a.ClientInvNbr, a.Amount, a.VendorID, a.InvoiceNbr, c.RefNbr, c.DocDate , c.CuryOrigDocAmt, c.DocType, a.Task 
from
 xvr_PA005_ActCom a(nolock) LEFT OUTER JOIN AP03630MC_Wrk c ON (a.InvoiceNbr = c.APDocVO_InvcNbr AND a.VendorID = c.VendId)
 where (a.InvoiceNbr <> '' AND a.VendorID <> '')
 
 select top 100 * from PJINVHDR

 
 
 



 
 




                 