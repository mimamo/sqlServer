USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdLSDet_PONbr_InvtId_LotSe]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdLSDet_PONbr_InvtId_LotSe                           ******/
Create Proc [dbo].[PurOrdLSDet_PONbr_InvtId_LotSe] @parm1 varchar ( 10), @parm2 int, @parm3 varchar (30), @parm4 varchar(25) as
       Select * from PurOrdLSDet
                where PONbr = @parm1
                  and LineId = @parm2
                  and InvtId = @parm3
                  and LotSerNbr = @parm4
                order by PONbr, LineId, InvtId, LotSerNbr
GO
