USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BATCH_uSTATUS]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[BATCH_uSTATUS] @parm1 varchar (10) , @parm2 varchar (2), @parm3 varchar (1)  as
update BATCH set status = @parm3
where batnbr = @parm1
and module = @parm2
GO
