USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Site_CpnyID]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Site_CpnyID    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Site_CpnyID    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[Site_CpnyID] @parm1 varchar ( 10), @parm2 varchar(10) as
    Select * from Site where CpnyID = @parm1 and SiteId like @parm2 order by CpnyID, SiteId
GO
