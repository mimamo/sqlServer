USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xqTM930DaysInRange]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xqTM930DaysInRange] 
as 
select ri_id, fiscalno, begpernbr, endpernbr, 
(select sum(user2) from pjfiscal ifc where ifc.fiscalno between begpernbr and endpernbr) DayCount
from rptruntime rp 
cross join pjfiscal 
where fiscalno between begpernbr and  endpernbr
GO
