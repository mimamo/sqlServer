USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_delete]    Script Date: 12/21/2015 16:01:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMDET_delete] @parm1 varchar (10) as
Delete from PJTIMDET
WHERE
docnbr = @parm1
Delete from PJUOPDET
WHERE
docnbr = @parm1
GO
