USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJINVSEC_SPK0]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJINVSEC_SPK0] @parm1 varchar (4) , @parm2 varchar (4) ,  @parm3 varchar (16)   as
select * from PJINVSEC
where inv_format_cd = @parm1
and section_num like @parm2
and acct         like     @parm3
order by inv_format_cd,
section_num,
acct
GO
