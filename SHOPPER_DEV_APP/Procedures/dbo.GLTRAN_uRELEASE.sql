USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTRAN_uRELEASE]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[GLTRAN_uRELEASE] @parm1 varchar (10) , @parm2 varchar (2)  as
update GLTRAN set rlsed=1
where batnbr = @parm1
and module = @parm2
GO
