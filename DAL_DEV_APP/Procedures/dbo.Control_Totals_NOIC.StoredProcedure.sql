USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Control_Totals_NOIC]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Control_Totals_NOIC] @parm1 Varchar ( 10), @parm2 Varchar ( 2) as
        select Sum (CuryDrAmt), Sum (CuryCrAmt), Sum (DrAmt), Sum (CrAmt) from GLTran where Batnbr = @parm1 and Module = @parm2 and TranType <> "IC"
GO
