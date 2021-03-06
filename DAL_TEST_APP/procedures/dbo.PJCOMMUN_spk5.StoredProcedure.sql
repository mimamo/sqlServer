USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_spk5]    Script Date: 12/21/2015 13:57:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMMUN_spk5] @parm1 varchar (1)   as
select * from PJCOMMUN, PJEMPLOY
where    PJCOMMUN.destination    = PJEMPLOY.employee
and    PJCOMMUN.msg_status     = @parm1
and    PJEMPLOY.em_id03        = ''
and   (PJEMPLOY.em_id06 = 1 OR PJEMPLOY.em_id06 = 2)
order by PJCOMMUN.destination,
PJCOMMUN.msg_status,
PJCOMMUN.crtd_datetime
GO
