USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_INVEN_ustat]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJ_INVEN_ustat] @parm1 varchar (1) , @parm2 varchar (30)   as
update PJ_INVEN
set status_pa = @parm1
where prim_key =  @parm2
GO
