USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_TranSrc_RefNbr]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerT_TranSrc_RefNbr    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.LotSerT_TranSrc_RefNbr    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[LotSerT_TranSrc_RefNbr] @parm1 varchar (2), @parm2 varchar (15) as
    Select * from LotSerT where TranSrc = @parm1
                  and RefNbr = @parm2
                  order by TranSrc, RefNbr
GO
