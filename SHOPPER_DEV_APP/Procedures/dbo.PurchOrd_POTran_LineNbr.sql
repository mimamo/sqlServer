USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_POTran_LineNbr]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_POTran_LineNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurchOrd_POTran_LineNbr] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
        Select * from POTran where
                PONbr = @parm1 and
                LineNbr between @parm2beg And @parm2end
        Order by PONbr, POLineRef, LineNbr
GO
