USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Pjptdsum_sInvBud]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[Pjptdsum_sInvBud] @parm1 varchar (16) , @parm2 varchar (4)  as
select * from PJPTDSUM  inner join PJINVSEC
		   on PJPTDSUM.acct  = pjinvsec.acct 
where PJPTDSUM.project = @parm1  and
pjinvsec.inv_format_cd  = @parm2
order by PJPTDSUM.project,
PJPTDSUM.pjt_entity,
PJPTDSUM.acct
GO
