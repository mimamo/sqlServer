USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBDET_scomm2]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBDET_scomm2] as
select PJSUBDET.*, PJSUBCON.vendid, PJ_ACCOUNT.*
from PJSUBDET, PJSUBCON, PJ_ACCOUNT
where    pjsubdet.project = pjsubcon.project
and pjsubdet.subcontract = pjsubcon.subcontract
and pjsubcon.status_sub = 'A'
and pjsubdet.gl_acct = pj_account.gl_acct
order by pjsubdet.project, pjsubdet.subcontract, pjsubdet.sub_line_item
GO
