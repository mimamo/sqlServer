USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SLSTAXHIST_sPK0]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[SLSTAXHIST_sPK0] @parm1 varchar (10) , @PARM2 varchar (6) , @PARM3 varchar (10)  as
select * from SLSTAXHIST
where taxid  =  @parm1 and
YrMon  =  @parm2 and
CpnyID = @parm3
order by taxid, YrMon
GO
