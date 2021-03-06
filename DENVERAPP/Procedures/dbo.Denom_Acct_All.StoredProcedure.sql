USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Denom_Acct_All]    Script Date: 12/21/2015 15:42:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Denom_Acct_All    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Denom_Acct_All] @parm1 varchar ( 4), @parm2 varchar ( 2), @parm3 varchar ( 2) as
       Select * from Account
           where CuryID <> ""
             and CuryID <> @parm1
                         and (right(AcctType,1) = @parm2 or right(AcctType,1) = @parm3)
             order by CuryID, Acct
GO
