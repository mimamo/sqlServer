USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_PONbr_LineId_LnNbr]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdLSDet_PONbr_LineId_LnNbr                           ******/
Create Proc [dbo].[PurOrdLSDet_PONbr_LineId_LnNbr] @parm1 varchar ( 10), @parm2 int, @parm3beg smallint, @parm3end smallint as
       Select * from PurOrdLSDet
                where PONbr = @parm1
                  and LineId = @parm2
                  and LineNbr between @parm3beg and @parm3end
                order by PONbr, LineId, LineNbr
GO
