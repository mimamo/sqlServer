/****** Script for SelectTopNRows command from SSMS  ******/
SELECT a.AdjBatNbr, a.AdjDRefNbr, a.AdjGDocType, a.AdjGRefNbr, a.AdjGDoc_BatNbr, a.CustID, a.Customer_Name, a.AdjGDoc_PerPost, a.AdjGDoc_OrigDocAmt
, ar.ProjectID
  FROM AR08820_Wrk a 
  left outer join ARTran ar on a.AdjBatNbr = ar.BatNbr
  where a.AdjGDoc_PerPost like '2011%'
  and a.CustID like '9%'
  
  -- this one!
  select * from ARTran where CustID like '9%' or CustID like '2%' or CustID like '3%' or CustID like '1la%' and FiscYr = '2011'
  
  
  select top 10 * from ARDoc where BatNbr = '803343'
  select top 10 * from ARTran where BatNbr = '803343'
  
  select top 10 * from GLTran where BatNbr = '803343'
  
  
  
  
  
  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct BillName
  FROM [DENVERAPP].[dbo].[AR08820_Wrk] a left outer join 
  Customer c on a.CustID = c.CustId 
  --where a.CustID = '9BBDO'
 where a.AdjDDoc_DocDate between '01/01/2011' and '12/31/2011' 
  
  
  