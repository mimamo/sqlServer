USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLGL_dbatch]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLGL_dbatch] @parm1 varchar (10) as
delete from PJALLGL
where alloc_batch = @parm1
GO
