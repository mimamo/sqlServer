USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_delete]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_delete] @parm1 varchar (10) as
Delete from PJEXPDET
WHERE
docnbr = @parm1
Delete from PJEXPAUD
WHERE
docnbr = @parm1
GO
