USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTRAN_uTrantype]    Script Date: 12/21/2015 14:05:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ARTRAN_uTrantype] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (2) as
update ARTRAN set TranType = @parm3
where batnbr = @parm1 and
      refnbr = @parm2
GO
