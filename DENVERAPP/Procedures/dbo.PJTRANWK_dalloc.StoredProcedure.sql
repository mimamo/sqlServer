USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_dalloc]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_dalloc] @parm1 varchar (10) as
delete from PJTRANWK
    where alloc_batch = @parm1
GO
