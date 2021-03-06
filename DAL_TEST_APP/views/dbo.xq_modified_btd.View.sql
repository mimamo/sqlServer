USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xq_modified_btd]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xq_modified_btd] 
as 
select draft_num, 
isnull((select sum(amount) from pjbill 
inner join pjtran 
on pjbill.project = pjtran.project 
where pjbill.project_billwith = pjinvhdr.project_billwith
and pjtran.acct in ('BTD', 'SALES TAX') 
and (pjtran.tr_id02 < pjinvhdr.invoice_num or invoice_num < '0')),0) Billed_To_Date 
from pjinvhdr
GO
