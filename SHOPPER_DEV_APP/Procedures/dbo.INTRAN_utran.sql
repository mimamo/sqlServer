USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTRAN_utran]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[INTRAN_utran] @parm1 varchar (1) , @parm2 varchar (10) , @parm3 smallint   as
update INTRAN
set pc_status = @parm1
where INTRAN.batnbr =  @parm2 and
INTRAN.linenbr =  @parm3
GO
