USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId5]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ItemCost_InvtId_SiteId5]
	@parm1 	varchar ( 30),
	@parm2 	varchar ( 10),
	@parm3	varchar ( 1),
	@parm4 	varchar ( 25)
AS
	Select 	*
   	from 	ItemCost
   	where 	InvtId = @parm1
            and SiteId = @parm2
            and LayerType = @parm3
            and SpecificCostId Like @parm4
	order by InvtId, SiteId, SpecificCostId
GO
