USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_dalloc]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_dalloc] @parm1 varchar (10) as
delete from PJTRANWK
    where alloc_batch = @parm1
GO
