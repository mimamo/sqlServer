USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_PONbr_InvtId]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_PONbr_InvtId    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[PurOrdDet_PONbr_InvtId] @parm1 varchar ( 10), @parm2 varchar ( 30) as
    Select * from PurOrdDet where PONbr = @parm1
         and InvtId = @parm2
         order by InvtId, PONbr
GO
