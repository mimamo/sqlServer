USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vt_08550CustBalSum]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create view [dbo].[vt_08550CustBalSum] as

Select 

a.custid, 
LastActDate = max(a.LastActDate),
TotFutureBal = sum(a.FutureBal),
TotCurrBal = sum(a.CurrBal)

from ar_balances a 
group by a.custid
GO
