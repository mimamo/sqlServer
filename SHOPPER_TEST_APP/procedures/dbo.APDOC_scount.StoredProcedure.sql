USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDOC_scount]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APDOC_scount] @parm1 varchar (10) , @parm2 varchar (10)   as
select COUNT(*) from APDOC
where APDOC.batnbr = @parm1 and
APDOC.refnbr = @parm2
GO
