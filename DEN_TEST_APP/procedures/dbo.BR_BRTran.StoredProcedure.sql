USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRTran]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRTran]
@parm1 char(40)
AS
Select *
from BRTran
where MainKey = @parm1
order by MainKey
GO
