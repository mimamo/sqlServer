USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMComp_Inv_Kit_Site_Stat_Ln2]    Script Date: 12/21/2015 16:00:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMComp_Inv_Kit_Site_Stat_Ln2] @KitID varchar ( 30), @KitSiteID varchar ( 10),
        @KitStatus varchar ( 1), @LineNbrBeg smallint, @LineNbrEnd smallint as
        Select * from Component, Inventory where
        	Component.Kitid = @KitID and
		Component.KitSiteid = @KitSiteID and
		Component.kitstatus = @KitStatus and
		Component.linenbr between @LineNbrBeg and @LineNbrEnd and
		Inventory.Invtid = Component.CmpnentID
        	Order by Component.Kitid, Component.Kitsiteid, Component.Kitstatus,
			Component.LineNbr, Component.Cmpnentid
GO
