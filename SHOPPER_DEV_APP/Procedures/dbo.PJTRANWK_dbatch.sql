USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_dbatch]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_dbatch] @parm1 varchar (6), @parm2 varchar (2), @parm3 varchar (10), @parm4 varchar (16)  as
delete from PJTRANWK
    where alloc_batch = ' ' and
    fiscalno = @parm1 and
    system_cd = @parm2 and
    batch_id = @parm3 and
    project = @parm4
GO
