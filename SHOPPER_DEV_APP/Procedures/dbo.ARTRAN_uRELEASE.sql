USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTRAN_uRELEASE]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARTRAN_uRELEASE] @parm1 varchar (10) as
update ARTRAN set rlsed=1
where batnbr = @parm1
GO
