USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BATCH_uSTATUS]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[BATCH_uSTATUS] @parm1 varchar (10) , @parm2 varchar (2), @parm3 varchar (1)  as
update BATCH set status = @parm3
where batnbr = @parm1
and module = @parm2
GO
