USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRBatTran]    Script Date: 12/21/2015 15:49:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRBatTran]
@parm1 char(40)
AS
Select *
from BRBatTran
where MainKey = @parm1
order by MainKey
GO
