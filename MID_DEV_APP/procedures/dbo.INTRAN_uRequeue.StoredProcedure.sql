USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTRAN_uRequeue]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[INTRAN_uRequeue]  @parm1 varchar (6)  as
update INTRAN
set pc_status = '1'
where
INTRAN.perpost =  @parm1  and
INTRAN.pc_status =  '9'
GO
