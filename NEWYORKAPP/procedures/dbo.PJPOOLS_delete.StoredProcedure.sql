USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPOOLS_delete]    Script Date: 12/21/2015 16:01:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPOOLS_delete] @parm1 varchar (10) as
delete from pjpools where period = @parm1
GO
