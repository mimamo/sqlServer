USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_ItemCost_SpecID_GetUnitCost]    Script Date: 12/21/2015 13:45:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_ItemCost_SpecID_GetUnitCost]
	@InvtID varchar(30),
	@SiteID varchar(10),
	@SpecificCostID varchar(25)

as

	Select 	UnitCost
	from 	ItemCost
        where 	InvtId = @InvtID
   	  and 	SiteId = @SiteID
	  and 	SpecificCostId = @SpecificCostID
GO
