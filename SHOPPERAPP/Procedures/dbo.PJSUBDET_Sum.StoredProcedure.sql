USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBDET_Sum]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBDET_Sum]  @parm1 varchar (16) , @parm2 varchar (16)   as
select sum(original_amt), sum(revised_amt), sum(co_pend_amt), sum(vouch_amt), PJSUBDET.project, PJSUBDET.subcontract
from PJSUBDET
where
PJSUBDET.project       =    @parm1 and
PJSUBDET.subcontract   =    @parm2
group by PJSUBDET.project, PJSUBDET.subcontract
GO
