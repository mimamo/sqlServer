USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjcommun_spk3w_Co]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[pjcommun_spk3w_Co] @parm1 varchar (50), @parm2 varchar (50) as

select PJCOMMUN.*, PJEMPLOY.emp_name as send_desc  from PJCOMMUN LEFT OUTER JOIN PJEMPLOY
on  PJCOMMUN.sender = PJEMPLOY.employee  
where  PJCOMMUN.destination = @parm1 or  (PJCOMMUN.destination = @parm2 and destination_type = 'U')
order by 
PJCOMMUN.msg_status,
PJCOMMUN.crtd_datetime
GO
