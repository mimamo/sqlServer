USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOSUBD_SLINES]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOSUBD_SLINES]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (4)   as
select * from PJCOSUBD
where project       =    @parm1 and
subcontract   =    @parm2 and
sub_line_item like @parm3
order by
project, subcontract, sub_line_item
GO
