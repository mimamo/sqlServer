USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_LineNbr]    Script Date: 12/21/2015 14:34:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_PONbr_LineNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurOrdDet_PONbr_LineNbr] @parm1 varchar ( 10), @parm2 smallint as
    Select * from PurOrdDet where PONbr = @parm1
         and LineNbr = @parm2
         order by PONbr, LineNbr
GO
