USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOSUBD_SPROJ]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOSUBD_SPROJ]  @parm1 varchar (16)  as
select * from PJCOSUBD
where project       =    @parm1
GO
