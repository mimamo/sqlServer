USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xq_prebill_invoices]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xq_prebill_invoices] 
as 
select distinct tr_id02 invnbr 
from pjtran 
where acct = 'PREBILL'
GO
