USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_PurOrdLSDet_PONbr_LnId]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_PurOrdLSDet_PONbr_LnId                            ******/
Create Proc [dbo].[Delete_PurOrdLSDet_PONbr_LnId] @parm1 varchar ( 10), @parm2 int as
    Delete PurOrdLSDet from PurOrdLSDet
                where PurOrdLSDet.PONbr = @parm1
                  and PurOrdLSDet.LineId = @parm2
GO
