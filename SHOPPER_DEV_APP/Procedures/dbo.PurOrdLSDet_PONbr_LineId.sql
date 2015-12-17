USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_PONbr_LineId]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdLSDet_PONbr_LineId                                 ******/
Create Proc [dbo].[PurOrdLSDet_PONbr_LineId] @parm1 varchar ( 10), @parm2 int as
       Select * from PurOrdLSDet
                where PONbr = @parm1
                  and LineId = @parm2
                order by PONbr, LineId
GO
