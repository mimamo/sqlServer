USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJMX_SPK1]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJMX_SPK1] @parm1 varchar (16), @parm2 varchar (32), @parm3 varchar (16) as
select PJPROJMX.*, PJPTDROL.*
from PJPROJMX
	left outer join PJPTDROL
		on pjprojmx.project = pjptdrol.project
		and pjprojmx.acct = pjptdrol.acct
where pjprojmx.project = @parm1 and
	pjprojmx.pjt_entity = @parm2 and
	pjprojmx.acct like @parm3
order by pjprojmx.project, pjprojmx.pjt_entity, pjprojmx.acct
GO
