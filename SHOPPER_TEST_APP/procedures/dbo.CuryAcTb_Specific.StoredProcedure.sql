USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CuryAcTb_Specific]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CuryAcTb_Specific    Script Date: 4/7/98 12:43:41 PM ******/
Create Procedure [dbo].[CuryAcTb_Specific] @parm1 varchar ( 4), @parm2 varchar ( 10) AS
    Select * from CuryAcTb
    Where CuryAcTb.CuryId = @parm1
    and   CuryAcTb.AdjAcct = @parm2
GO
