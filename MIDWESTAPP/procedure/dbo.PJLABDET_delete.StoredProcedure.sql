USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLABDET_delete]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJLABDET_delete] @parm1 varchar (10) as
Delete from PJLABDET
WHERE
docnbr = @parm1
Delete from PJLABDLY
WHERE
docnbr = @parm1
Delete from PJLABAUD
WHERE
docnbr = @parm1
GO
