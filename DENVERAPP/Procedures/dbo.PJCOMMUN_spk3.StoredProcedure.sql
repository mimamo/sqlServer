USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_spk3]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMMUN_spk3] @parm1 varchar (10)   as
select *
	from PJCOMMUN
		left outer join PJEMPLOY
			on PJCOMMUN.sender = PJEMPLOY.employee
	where PJCOMMUN.destination  = @parm1
	order by PJCOMMUN.destination,
		PJCOMMUN.msg_status,
		PJCOMMUN.crtd_datetime
GO
