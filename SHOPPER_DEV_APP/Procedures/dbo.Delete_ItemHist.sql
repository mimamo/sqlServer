USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_ItemHist]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_ItemHist]
    @parm1 varchar ( 4),
    @Parm2 varchar (10)
as
Delete ItemHist
  From ItemHist Join Site
       on  ItemHist.SiteID = Site.SiteID
  Where ItemHist.FiscYr <= @parm1
    And Site.CpnyID = @Parm2
GO
