USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sALLEX]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sALLEX] @parm1 varchar (16) , @parm2 varchar (32)   as
select *
from PJPENT
	left outer join PJPENTEX
		on pjpent.project = pjpentex.project
		and pjpent.pjt_entity = pjpentex.pjt_entity
where pjpent.project = @parm1 and
	pjpent.pjt_entity like @parm2
order by pjpent.project, pjpent.pjt_entity
GO
