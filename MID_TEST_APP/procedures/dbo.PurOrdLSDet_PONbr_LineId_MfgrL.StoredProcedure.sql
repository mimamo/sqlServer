USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_PONbr_LineId_MfgrL]    Script Date: 12/21/2015 15:49:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdLSDet_PONbr_LineId_MfgrL                           ******/
Create Proc [dbo].[PurOrdLSDet_PONbr_LineId_MfgrL] @parm1 varchar ( 10), @parm2 int, @parm3 varchar(25) as
       Select * from PurOrdLSDet
                where PONbr = @parm1
                  and LineId = @parm2
                  and MfgrLotSerNbr = @parm3
                Order By PoNbr, LineId, MfgrLotSerNbr
GO
