USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRBat_Grid]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRBat_Grid]
@parm1 char(10),
@parm2 char(40)
AS
Select *
from BRBatTran
where AcctID = @parm1
and BatTranID = @parm2
order by AcctID, ARBatNbr, MainKey
GO
