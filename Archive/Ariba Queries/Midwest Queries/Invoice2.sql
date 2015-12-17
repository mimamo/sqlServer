declare @perPost int
set @perPost = 201303

select 
--b.acct,
LTRIM(RTRIM(b.refnbr)) as InvoiceId,
REPLACE(LTRIM(RTRIM(a.invcnbr)),',','')as ExtraInvoiceKey,
LTRIM(RTRIM(b.Lineref)) as InvoiceLineNumber,
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
LTRIM(RTRIM(b.acct)) as AccountId,
'' as AccountCompanyCode,
b.CpnyID as CompanySiteId,
b.CpnyID as CostCenterId,
'4usINMID' as CostCenterCompanyCode,
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
IsNull((SELECT LTRIM(RTRIM(pm_id01)) FROM PJPROJ where project = b.ProjectID), ' ') as FlexFieldId6

from apdoc a, aptran b
     
where (a.refnbr = b.refnbr 
AND a.DocType IN ('VO','AD')
AND b.acct NOT IN (2045,2046,2047)
AND (b.Acct >= 6000 OR b.Acct <= 6500)
AND b.LineNbr <> 32767
AND a.PerPost = @perPost)

--ORDER BY a.PerPost
