USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Item2Hist]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Delete_Item2Hist]
    @parm1 varchar ( 4),
    @Parm2 varchar (10)
as
Delete Item2Hist
  From Item2Hist Join Site
       on  Item2Hist.SiteID = Site.SiteID
  Where Item2Hist.FiscYr <= @parm1
    And Site.CpnyID = @Parm2
GO
