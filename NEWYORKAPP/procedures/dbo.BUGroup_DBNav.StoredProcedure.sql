USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[BUGroup_DBNav]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BUGroup_DBNav] @Parm1 varchar ( 10), @Parm2 varchar ( 4), @Parm3 varchar ( 10),
@Parm4 varchar ( 24), @Parm5 varchar (47) AS
SELECT * FROM Budget_Group WHERE CpnyId = @Parm1 And
budgetyear = @Parm2 And BudgetLedgerID = @Parm3 And BdgtSegment
= @Parm4 And GroupID Like @Parm5
ORDER BY CpnyID, BudgetYear, BudgetLedgerid, BdgtSegment, GroupId
GO
