USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_SumExtCost]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POTran_SumExtCost    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POTran_SumExtCost] @parm1 varchar ( 10) As
Select sum(curyextcost), sum(extcost) From POTran
   Where POTran.RcptNbr = @parm1 And POTran.POOriginal = 'Y'
GO
