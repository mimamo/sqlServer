USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId5]    Script Date: 12/21/2015 15:42:57 ******/
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
