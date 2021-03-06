USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk2]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spk2] @parm1 varchar (16) , @parm2 varchar (2)  as
select * from PJBILL, PJPTDSUM, PJINVSEC, PJPROJ
where pjbill.project = PJPTDSUM.project and
PJPTDSUM.project  = pjproj.project    and
PJPTDSUM.acct  = pjinvsec.acct    and
pjbill.project_billwith = @parm1  and
pjinvsec.inv_format_cd  = @parm2
order by PJPTDSUM.project,
PJPTDSUM.pjt_entity,
PJPTDSUM.acct
GO
