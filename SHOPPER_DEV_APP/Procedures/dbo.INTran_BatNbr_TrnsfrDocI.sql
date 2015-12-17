USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_TrnsfrDocI]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_BatNbr_TrnsfrDocI    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_BatNbr_TrnsfrDocI    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_BatNbr_TrnsfrDocI] @parm1 varchar ( 10) as
    Select * from INTran
        where INTran.BatNbr = @parm1
        and INTran.ToSiteId <> ''
        order by BatNbr, InvtId, SiteId, WhseLoc, RefNbr, LineNbr
GO
