USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ledger_Actual_only]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Ledger_Actual_only] @parm1 varchar ( 10) as
Select * from Ledger
where LedgerID   like @parm1
and balancetype = "A"
order by LedgerID
GO
