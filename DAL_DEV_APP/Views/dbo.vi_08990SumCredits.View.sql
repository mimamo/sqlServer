USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[vi_08990SumCredits]    Script Date: 12/21/2015 13:35:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create view [dbo].[vi_08990SumCredits] as

select v.custid, v.cpnyid, amount = sum(adjamt), discamt = sum(adjdiscamt), v.adjgperpost, v.updflag, 
FiscalYr = SUBSTRING(v.adjgperpost,1, 4), PerNbr = SUBSTRING(v.adjgperpost,5, 2)

from vi_08990SelectCredits v 

group by v.custid, v.cpnyid, v.adjgperpost, v.updflag
GO
