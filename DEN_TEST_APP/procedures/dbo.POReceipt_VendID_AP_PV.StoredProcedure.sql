USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_VendID_AP_PV]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_VendID_AP_PV    Script Date: 11/24/99 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_VendID_AP_PV] @parm1 varchar ( 15), @parm2 varchar ( 10) As
        Select distinct r.* From POReceipt r
	inner join potran t on t.rcptnbr = r.rcptnbr
	where
                r.VendID = @parm1
                And r.Rlsed = 1
                And r.VouchStage <> 'F'
		And r.RcptType <> 'X'
                And r.RcptNbr LIKE @parm2
        Order By r.VendID, r.RcptNbr
GO
