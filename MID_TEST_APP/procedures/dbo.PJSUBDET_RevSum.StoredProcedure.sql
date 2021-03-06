USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBDET_RevSum]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBDET_RevSum]  @parm1 varchar (16) , @parm2 varchar (16)   as
select  sum(revised_amt), sum(prior_request_amt), PJSUBDET.project, PJSUBDET.subcontract
from PJSUBDET
where
PJSUBDET.project       =    @parm1 and
PJSUBDET.subcontract   =    @parm2
group by PJSUBDET.project, PJSUBDET.subcontract
GO
