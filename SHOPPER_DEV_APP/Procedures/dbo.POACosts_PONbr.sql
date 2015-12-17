USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POACosts_PONbr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POACosts_PONbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[POACosts_PONbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from POACosts where
        PONbr = @parm1 and
                InvcTypeID like @parm2
        Order by PONbr, InvcTypeID
GO
