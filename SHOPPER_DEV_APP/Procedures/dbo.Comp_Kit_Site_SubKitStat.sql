USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_Site_SubKitStat]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_Kit_Site_SubKitStat] @parm1 varchar ( 30),@parm2 varchar ( 10),@parm3 varchar ( 1)  as
        Select Kit.* from Kit where
        Kit.Kitid = @parm1 and Kit.Siteid = @parm2 and
        Kit.status = @parm3
         Order by Kit.Kitid, Kit.Siteid, Kit.Status
-- KMT: Find valid sites for a selected BMID.
-- Used in 11.010 as PV for Site ID.
GO
