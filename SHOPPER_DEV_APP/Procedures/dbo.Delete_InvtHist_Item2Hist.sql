USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_InvtHist_Item2Hist]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_InvtHist_Item2Hist]
    @parm1 varchar ( 30),
    @parm2 varchar ( 10),
    @parm3 varchar ( 4)
as
Delete from Item2Hist
    where InvtId = @parm1
      and SiteId = @parm2
      and FiscYr = @parm3
GO
