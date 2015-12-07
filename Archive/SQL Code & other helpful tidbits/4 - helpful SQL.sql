--SQL Helpful Queries

select * from PJPROJ where manager1 = 'nzumbro' and status_pa = 'A' -- list project managers for active projects

EXEC sp_table_privileges '[table_name]'   -- get the privilages for a table

EXEC sp_helptext '[view_name]' --get the info for building the view

-- Update Invoice format 
begin tran
UPDATE PJINVHDR
SET inv_format_cd = '[format number]' 
WHERE invoice_num in ('[invoice number(s)]') 
commit

-- Set Product Codes on Job’supdate PJPROJset pm_id02 ='WMTR'   where project in ('04519212AGY')Update PJBILLSet biller ='WMTR'where project in ('04519212AGY')

-- Update invoice date in PJINVHDR
select * from pjinvdet where invoice_num in ('[invoice number(s)]')

update pjinvhdr 
set invoice_date = '[Date]'
where invoice_num in ('[invoice number(s)]')


-- Find GL invoices with specific account and sub combos
select distinct g.ProjectID, g.Acct, g.SUB, g.FiscYr, g.CrAmt, g.DrAmt, c.CustId, c.Name as CustName, c.ArAcct, c.ArSub, g.RefNbr  
from GLTran g LEFT OUTER JOIN PJPROJ p ON g.ProjectID = p.project	
left outer join Customer c ON p.customer = c.CustId
where g.Acct = '1040' and g.SUB = '1000' and g.JrnlType = 'IN'
order by g.FiscYr

--Copy Screen info from Production if screen gets messed up in development
 select * from CustomVBA where screenid = 'PAPRJ00' --this is the screen ID for the screen you were working on
 
 begin tran
 delete from CustomVBA where screenid = 'PAPRJ00'
 insert into CustomVBA (CustomId, Description, EntityId, RecordIndex, ScreenId, Sequence, Version, PropData) 
 select CustomId, Description, EntityId, RecordIndex, ScreenId, Sequence, Version, PropData 
	from SQL1.DENVERSYS.dbo.CustomVBA where screenid = 'PAPRJ00' --this is the screen ID for the screen you were working on
 
 commit 

-- Get the security for any table in the database
EXEC sp_table_privileges 
   @table_name = '%';

--Sample SQL for updating a job# in pjlabhdrupdate pjlabdet dleft join pjlabhdr hon d.docnbr = h.docnbrset d.project = '04387111AGY'where d.project = '04072011AGY' and h.le_id03 = '' and h.pe_date > '2011-01-01'-- complete examplebegin tranupdate pjlabdet--select pjlabhdr.le_status,pjlabdet.* set pjlabdet.project = '04387711AGY'where pjlabdet.project = '01215602AGY' and docnbr in (select pjlabdet.docnbr from pjlabdet left join pjlabhdr on pjlabdet.docnbr = pjlabhdr.docnbrwhere pjlabdet.project = '01215602AGY' and pjlabhdr.le_id03 = '' and pjlabhdr.pe_date > '2011-01-01')rollbackcommitselect pjlabhdr.le_status,pjlabhdr.pe_date,pjlabdet.* from pjlabdetleft join pjlabhdr on pjlabdet.docnbr = pjlabhdr.docnbrwhere pjlabdet.project = '01215602AGY' and pjlabhdr.le_id03 = '' and pjlabhdr.pe_date > '2011-01-01'
--Extracting Timecards from PJLABDET and PJLABHDR/*Don’t forget any change to a timecard record in DSL may need the record changed in the source timekeeping system database as well.select*/	employee,	pe_date,	le_id03,	le_status,	pjlabhdr.docnbr,	project,	total_hrsfrom pjlabhdr, pjlabdetwhere pjlabhdr.docnbr = pjlabdet.docnbr and le_id03 =''and employee = 'trathgeber'

--Here is the query that will pull activity for KPMG Audit. 

Select b.BatNbr
, b.Crtd_DateTime as BatchCrtd_datetime
, t.Acct
, t.Sub
, t.JrnlType
, t.FiscYr
, t.PerEnt
, t.PerPost
, b.BatType
, t.CuryCrAmt
, t.CuryDrAmt
, t.CuryId
, t.TranDesc
, b.AutoRev
, t.Crtd_User
, t.Crtd_DateTime
, t.LUpd_User
, t.LUpd_DateTime
from Batch b JOIN GLTran t ON b.BatNbr = t.BatNbr
Where t.FiscYr = '2012'
AND t.PerEnt = '201202'
       and t.LedgerID = 'ACTUAL'
       
       
----- Query to update Bridge Client Product Glossary
INSERT INTO OPENQUERY ([xRHSQL.butler], 'SELECT type, clientID, ClientName, clientStatus, ProdID, Product, ProductStatus, ProductGroup FROM butler.client_product_glossary_changes')
SELECT [type], clientID, ClientName, clientStatus, ProdID, Product, ProductStatus, ProductGroup
FROM DENVERAPP..xCPG
WHERE prodID not in (SELECT * FROM OPENQUERY([xRHSQL.butler], 'SELECT ProdID FROM butler.client_product_glossary_changes'))