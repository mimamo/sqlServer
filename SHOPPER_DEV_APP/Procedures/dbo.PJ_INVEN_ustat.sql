USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJ_INVEN_ustat]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJ_INVEN_ustat] @parm1 varchar (1) , @parm2 varchar (30)   as
update PJ_INVEN
set status_pa = @parm1
where prim_key =  @parm2
GO
