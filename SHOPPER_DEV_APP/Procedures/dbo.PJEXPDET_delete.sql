USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_delete]    Script Date: 12/16/2015 15:55:26 ******/
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
