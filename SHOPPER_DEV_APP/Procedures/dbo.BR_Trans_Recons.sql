USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_Trans_Recons]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_Trans_Recons]
@cpnyid char(10),
@parm1 char(10),
@parm2 char(6),
@parm3 varchar(40)
AS
Select *
from BRTran
where CpnyID = @CpnyID
and AcctID = @parm1
and CurrPerNbr = @parm2
and Mainkey like @parm3
order by AcctID, CurrPerNbr, MainKey
GO
