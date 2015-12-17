USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SLSTAXHIST_sPK0]    Script Date: 12/16/2015 15:55:33 ******/
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
