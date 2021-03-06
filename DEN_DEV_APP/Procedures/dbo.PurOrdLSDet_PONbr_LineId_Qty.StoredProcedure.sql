USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_PONbr_LineId_Qty]    Script Date: 12/21/2015 14:06:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdLSDet_PONbr_LineId_Qty                             ******/
Create Proc [dbo].[PurOrdLSDet_PONbr_LineId_Qty] @parm1 varchar ( 10), @parm2 int as
Select PONbr, LineId, sum(Qty) from PurOrdLSDet
       where  PONbr = @parm1 and
 	       LineId = @parm2
   	 Group By  PONbr, LineId
GO
