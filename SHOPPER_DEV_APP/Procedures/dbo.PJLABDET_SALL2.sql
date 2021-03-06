USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_SALL2]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_SALL2]  @parm1 varchar (10) , @parm2beg smallint , @parm2end smallint   as
select *
from PJLABDET
	left outer join PJPROJ
		on pjlabdet.project = pjproj.project
	left outer join PJPENT
		on pjlabdet.project = pjpent.project
		and pjlabdet.pjt_entity = pjpent.pjt_entity
where docnbr = @parm1 and
	linenbr  between  @parm2beg and @parm2end
order by docnbr, linenbr
GO
