USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_spk1]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMMUN_spk1] @parm1 varchar (6) , @parm2 varchar (48) , @parm3 varchar (2)   as
SELECT * from PJCOMMUN
WHERE
        msg_type = @parm1 and
msg_key = @parm2 and
msg_suffix = @parm3
ORDER BY
destination,
msg_status,
PJCOMMUN.crtd_datetime
GO
