USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTRAN_utran]    Script Date: 12/21/2015 13:57:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[GLTRAN_utran] @parm1 varchar (1) , @parm2 varchar (2) , @parm3 varchar (10) , @parm4 smallint   as
update GLTRAN
set pc_status = @parm1
where GLTRAN.module =  @parm2 and
GLTRAN.batnbr = @parm3 and
GLTRAN.linenbr =  @parm4
GO
