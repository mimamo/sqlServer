USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJUOPDET_Sgrid]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUOPDET_Sgrid] @parm1 varchar (10) , @parm2beg smallint , @parm2end smallint as
select PJUOPDET.*, PJPENTEX.*
from PJUOPDET
	left outer join PJPENTEX
		on 	pjuopdet.project = pjpentex.project
		and pjuopdet.pjt_entity = pjpentex.pjt_entity
where (docnbr = @parm1 and
	linenbr between @parm2beg and @parm2end)
order by PJUOPDET.docnbr, PJUOPDET.linenbr
GO
