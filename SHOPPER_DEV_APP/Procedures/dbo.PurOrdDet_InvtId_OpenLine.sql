USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurOrdDet_InvtId_OpenLine]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurOrdDet_InvtId_OpenLine    Script Date: 4/16/98 7:50:26 PM ******/
create proc [dbo].[PurOrdDet_InvtId_OpenLine] @parm1 varchar(30) as
        Select * from PurOrdDet where InvtId = @parm1 And OpenLine = 1
                Order by InvtId
GO
