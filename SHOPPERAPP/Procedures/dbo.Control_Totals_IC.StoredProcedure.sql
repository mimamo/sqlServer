USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Control_Totals_IC]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Control_Totals_IC] @parm1 Varchar ( 10), @parm2 Varchar ( 2) as
        select Sum (CuryDrAmt), Sum (CuryCrAmt), Sum (DrAmt), Sum (CrAmt) from GLTran where Batnbr = @parm1 and Module = @parm2
GO
