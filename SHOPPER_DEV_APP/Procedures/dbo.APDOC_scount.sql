USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDOC_scount]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APDOC_scount] @parm1 varchar (10) , @parm2 varchar (10)   as
select COUNT(*) from APDOC
where APDOC.batnbr = @parm1 and
APDOC.refnbr = @parm2
GO
