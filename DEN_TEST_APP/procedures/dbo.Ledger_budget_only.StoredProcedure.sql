USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ledger_budget_only]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Ledger_budget_only] @parm1 varchar ( 10) as
Select * from Ledger
where LedgerID   like @parm1
and balancetype = "B"
order by LedgerID
GO
