USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId_OM]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ItemCost_InvtId_SiteId_OM]
	@parm1 	varchar ( 30),
	@parm2 	varchar ( 10),
	@parm3 	varchar ( 25)

AS

  Select 	*
  from 		vp_ItemCost_OM
  where 	InvtId = @parm1
            	and SiteId = @parm2
		and SpecificCostId Like @parm3
  order by	InvtId, SiteId, SpecificCostId
GO
