USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Checkfor_OMBatch]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[Checkfor_OMBatch] @parm1 varchar (10) as
select jrnltype from batch where batnbr = @parm1 and module = "AR" and jrnltype = "OM"
Order by batnbr,module
GO
