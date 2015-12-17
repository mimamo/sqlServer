USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smPJPROJ_spk1_CpnyID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[smPJPROJ_spk1_CpnyID]
	@parm1 varchar (15)
	,@parm2 varchar(10)
	,@parm3 varchar(16)

as
	select * from PJPROJ
where
	customer = @parm1
		AND
	cpnyid = @parm2
		AND
	project like @parm3
		AND
	status_pa  =    "A"
	order by project
GO
