USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLGL_dbatch]    Script Date: 12/21/2015 16:01:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLGL_dbatch] @parm1 varchar (10) as
delete from PJALLGL
where alloc_batch = @parm1
GO
