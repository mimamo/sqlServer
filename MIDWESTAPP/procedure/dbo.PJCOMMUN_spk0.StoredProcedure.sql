USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMMUN_spk0]    Script Date: 12/21/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMMUN_spk0] @parm1 varchar (10)   as
select * from PJCOMMUN
where    destination    =    @parm1
order by destination,
msg_status,
PJCOMMUN.crtd_datetime
GO
