USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_PurOrdDet_PONbr]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_PurOrdDet_PONbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[Delete_PurOrdDet_PONbr] @parm1 varchar ( 10) As
Delete from PurOrdDet Where PONbr = @parm1
GO
