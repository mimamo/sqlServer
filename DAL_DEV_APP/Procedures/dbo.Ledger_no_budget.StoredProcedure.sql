USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ledger_no_budget]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Ledger_no_budget    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc [dbo].[Ledger_no_budget] @parm1 varchar ( 10) as
Select * from Ledger
where LedgerID   like @parm1
and (balancetype = "S" or balancetype = "A" or balancetype = "R")
order by LedgerID
GO
