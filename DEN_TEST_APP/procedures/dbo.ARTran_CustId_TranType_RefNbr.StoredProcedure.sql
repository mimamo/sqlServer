USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_CustId_TranType_RefNbr]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_CustId_TranType_RefNbr    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_CustId_TranType_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 8), @parm4 varchar ( 10), @parm5 varchar ( 2), @parm6 varchar ( 10) as
    Select * from ARTran With (index = artran9) where
            ARTran.BatNbr = @parm1
            and ARTran.CustId = @parm2
            and ARTran.CostType = @parm3
            and ARTran.SiteId = @parm4
            and ARTran.TranType like @parm5
            and ARTran.RefNbr like @parm6
            and ARTran.DrCr = 'U'
            order by Batnbr, CustId, TranType, RefNbr
GO
