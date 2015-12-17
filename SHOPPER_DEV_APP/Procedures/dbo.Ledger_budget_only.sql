USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ledger_budget_only]    Script Date: 12/16/2015 15:55:24 ******/
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
