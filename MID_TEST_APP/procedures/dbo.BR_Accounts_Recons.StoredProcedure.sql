USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_Accounts_Recons]    Script Date: 12/21/2015 15:49:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_Accounts_Recons]
@parm1 char(10),
@parm2 char(10),
@parm3 char(6)
AS
Select *
from BRHeader
where cpnyid = @parm1 and AcctID = @parm2
and ReconPerNbr = @parm3
order by AcctID, ReconPerNbr
GO
