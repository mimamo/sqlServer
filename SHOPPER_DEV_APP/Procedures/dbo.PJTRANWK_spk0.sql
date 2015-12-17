USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_spk0]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_spk0] @parm1 varchar (6), @parm2 varchar (2), @parm3 varchar (10)  as
select * from PJTRANWK
    where alloc_batch = ' ' and
    fiscalno = @parm1 and
    system_cd = @parm2 and
    batch_id = @parm3
    order by alloc_batch, fiscalno, system_cd, batch_id, project
GO
