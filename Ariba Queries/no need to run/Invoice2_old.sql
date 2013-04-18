select a.Acct,
b.refnbr as InvoiceId,
REPLACE(LTRIM(RTRIM(a.invcnbr)),',','')as ExtraInvoiceKey,
b.Lineref as InvoiceLineNumber,
b.LineNbr * -1 as ExtraInvoiceLineKey,
'' as SplitAccountingNumber,
COALESCE(LEFT(CONVERT(VARCHAR,a.docdate, 120), 10),'') as AccountingDate,
'' as Quantity,
case when DrCr = 'C' then
b.CuryTranAmt * -1 else b.CuryTranAmt end as Amount,
'USD' as AmountCurrency,
REPLACE(LTRIM(RTRIM(B.TranDesc)),',',' ')as Description,
'' as ERPCommodityId,
'' as PartNumber,
'' as PartRevisionNumber,
'' as UnitOfMeasure,
LTRIM(RTRIM(a.Vendid)) as SupplierId,
'' as SupplierLocationId,
'' as RequesterId,
b.acct as AccountId,
'' as AccountCompanyCode,
b.CpnyID as CompanySiteId,
b.CpnyID as CostCenterId,
CASE WHEN b.CpnyID ='PROED' THEN '3usKALLIbal'
ELSE CASE WHEN b.CPnyID = 'MOSAIC' THEN '3usRXMOS' 
ELSE '3usHSCOM'
END END 
as CostCenterCompanyCode,
'' as ContractId,
'' as POId,
'' as ExtraPOKey,
'' as POLineNumber,
'' as ExtraPOLineKey,
COALESCE(LEFT(CONVERT(VARCHAR,a.InvcDate, 120), 10),'')as InvoiceDate,
CASE
				/*For zero A/P documents, make paid date the same as invoice date*/
				WHEN a.OrigDocAmt = 0 
					THEN COALESCE(LEFT(CONVERT(VARCHAR,A.InvcDate, 120), 10),'')
				/*Else get the check date*/
				ELSE
					COALESCE(LEFT(CONVERT(VARCHAR,(SELECT MAX(C.adjgdocdate)
					 FROM	apadjust C
					 WHERE	C.adjdrefnbr = B.refnbr AND
							C.S4Future11 <> 'V'), 120), 10),'')
			END AS 'PaidDate',

REPLACE(LTRIM(RTRIM(A.invcnbr)),',',' ') as InvoiceNumber,
'' as APPaymentTerms,
'' as LineType,
'' as FlexFieldId1,
'' as FlexFieldId2,
'' as FlexFieldId3,
'' as FlexFieldId4,
'' as FlexFieldId5,
left(b.projectID,7) as FlexFieldId6

from apdoc a, aptran b
     
where (a.refnbr = b.refnbr 
AND (a.DocType = 'VO' OR a.DocType = 'AD') 
-- this is for the accounts that we are excluding from the report
AND b.acct <> 2000
-- Change the per post each month
AND a.PerPost = 201111)
