USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQRATE_sequipid]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQRATE_sequipid] @parm1 varchar (10) , @parm2 varchar (16) , @parm3beg smalldatetime , @parm3end smalldatetime  as
select *
	from PJEQRATE
		left outer join PJPROJ
			on PJEQRATE.project = PJPROJ.project
	where PJEQRATE.equip_id = @parm1 and
		PJEQRATE.project like @parm2 and
		(PJEQRATE.effect_date  between @parm3beg and @parm3end)
	order by PJEQRATE.equip_id, PJEQRATE.project, PJEQRATE.effect_date
GO
