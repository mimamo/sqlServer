USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_InvtId]    Script Date: 12/21/2015 14:17:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_InvtId    Script Date: 4/16/98 7:50:26 PM ******/
create proc [dbo].[PurOrdDet_InvtId] @parm1 varchar ( 30) as
        Select * from PurOrdDet where InvtId = @parm1
                Order by InvtId
GO
