USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjcommun_spk3w_Home]    Script Date: 12/21/2015 13:57:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[pjcommun_spk3w_Home] @parm1 varchar (50), @parm2 varchar (50) as

select * from PJCOMMUN
where  (PJCOMMUN.destination = @parm1  or  (PJCOMMUN.destination = @parm2 and destination_type = 'U'))
        and PJCOMMUN.msg_status in ('N', 'P')
order by 
PJCOMMUN.msg_status,
PJCOMMUN.crtd_datetime
GO
