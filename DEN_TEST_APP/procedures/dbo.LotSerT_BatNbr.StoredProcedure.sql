USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_BatNbr]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_BatNbr    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[LotSerT_BatNbr] @parm1 varchar (2), @parm2 varchar ( 10), @parm3 varchar ( 30) as
    Select * from LotSerT where TranSrc = @parm1
                  and Batnbr = @parm2
                  and KitID = @parm3
                  order by TranSrc,BatNbr,KitID,INTranLineId
GO
