USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_sall]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_sall] @parm1 varchar (10), @parm2 varchar (16) as
select * from PJTRANWK
    where alloc_batch = @parm1
    and project = @parm2
GO
