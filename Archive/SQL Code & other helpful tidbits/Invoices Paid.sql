-- Get all of the invoices for MC (just like the Intelliview Inquiry)
select a.DocType as 'Invoice DocType'
, b.DocType as 'Paid DocType'
, a.ProjectID
, a.RefNbr as 'Invoice Number'
, b.RefNbr as 'Check Number'
, a.BatNbr as 'Invoice Batch Number'
, b.BatNbr as 'Paid Batch Number'
, a.DocDate as 'Invoice Date'
, a.DueDate as 'Due Date'
, b.DocDate as 'Paid Date'
, a.OrigAmt as 'Original Invoice Amount'
, a.BalApplied as 'Outstanding Balance'
, b.OrigAmt as 'Total Payment'
, (a.OrigAmt - a.BalApplied) as 'Amount Applied'
, a.PerPost as 'Invoice period Post'
, b.PerPost as 'Paid Period Post'
from
(select CASE
WHEN a.DocType = 'IN' THEN 'Invoice'
WHEN a.DocType = 'DM' THEN 'Debit Memo'
WHEN a.DocType = 'CM' THEN 'Credit Memo'
WHEN a.DocType = 'PA' THEN 'Payment'
WHEN a.DocType = 'DA' THEN 'Discount Allowed'
WHEN a.DocType = 'FI' THEN 'Finance Charge'
WHEN a.DocType = 'PP' THEN 'Prepayment'
WHEN a.DocType = 'SB' THEN 'Small Bal Write Off'
WHEN a.DocType = 'SC' THEN 'Small Credit W/O'
WHEN a.DocType = 'ZZ' THEN 'Other Document'
WHEN a.DocType = 'AD' THEN 'Applied to Debit Memo'
WHEN a.DocType = 'AI' THEN 'Applied to Invoice'
WHEN a.DocType = 'AF' THEN 'Appl to Fin Chrg'
WHEN a.DocType = 'AA' THEN 'Applied Discount'
WHEN a.DocType = 'AP' THEN 'Payment Applied'
WHEN a.DocType = 'AC' THEN 'Credit Memo Applied'
WHEN a.DocType = 'AW' THEN 'Write-Off Applied'
WHEN a.DocType = 'AZ' THEN 'Other Application'
WHEN a.DocType = 'CO' THEN 'Cross Apply Out'
WHEN a.DocType = 'CI' THEN 'Cross Apply IN'
WHEN a.DocType = 'TO' THEN 'Transfer Out'
WHEN a.DocType = 'TI' THEN 'Transfer In'
WHEN a.DocType = 'NP' THEN 'New Payment'
END as 'DocType'
, a.RefNbr
, a.BatNbr
, a.DocDate
, a.DueDate
, a.CuryOrigDocAmt as 'OrigAmt'
, a.CuryDocBal as 'BalApplied'
, a.ProjectID
, a.PerPost 
, b.AdjgRefNbr
, b.CustId
	from ARDoc a LEFT OUTER JOIN ARAdjust b ON a.RefNbr = b.AdjdRefNbr)a
LEFT OUTER JOIN
(select CASE
WHEN DocType = 'IN' THEN 'Invoice'
WHEN DocType = 'DM' THEN 'Debit Memo'
WHEN DocType = 'CM' THEN 'Credit Memo'
WHEN DocType = 'PA' THEN 'Payment'
WHEN DocType = 'DA' THEN 'Discount Allowed'
WHEN DocType = 'FI' THEN 'Finance Charge'
WHEN DocType = 'PP' THEN 'Prepayment'
WHEN DocType = 'SB' THEN 'Small Bal Write Off'
WHEN DocType = 'SC' THEN 'Small Credit W/O'
WHEN DocType = 'ZZ' THEN 'Other Document'
WHEN DocType = 'AD' THEN 'Applied to Debit Memo'
WHEN DocType = 'AI' THEN 'Applied to Invoice'
WHEN DocType = 'AF' THEN 'Appl to Fin Chrg'
WHEN DocType = 'AA' THEN 'Applied Discount'
WHEN DocType = 'AP' THEN 'Payment Applied'
WHEN DocType = 'AC' THEN 'Credit Memo Applied'
WHEN DocType = 'AW' THEN 'Write-Off Applied'
WHEN DocType = 'AZ' THEN 'Other Application'
WHEN DocType = 'CO' THEN 'Cross Apply Out'
WHEN DocType = 'CI' THEN 'Cross Apply IN'
WHEN DocType = 'TO' THEN 'Transfer Out'
WHEN DocType = 'TI' THEN 'Transfer In'
WHEN DocType = 'NP' THEN 'New Payment'
END as 'DocType' 
, RefNbr
, BatNbr
, DocDate
, SUM(CuryOrigDocAmt) as 'OrigAmt'
, PerPost 
, CustId
	from ARDoc
	group by DocType, RefNbr, BatNbr, DocDate, PerPost, CustId)b 
ON a.AdjgRefNbr = b.RefNbr and a.CustId = b.CustId
where a.CustId like '1MC%'
and a.DocDate > '1/1/2011'
order by a.DocDate
	
	