USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemCost_InvtId_SiteId4]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ItemCost_InvtId_SiteId4]
	@parm1 	varchar ( 30),
	@parm2 	varchar ( 10),
	@parm3 	varchar ( 25),
	@parm4	varchar ( 1),
	@parm5 	varchar ( 15)
AS
  Select 	*
  from 		ItemCost
  where 	InvtId = @parm1
            	and SiteId = @parm2
		and (SpecificCostId = @parm3 or SpecificCostID Is Null)
            	and LayerType = @parm4
            	and RcptNbr like @parm5
  order by	InvtId, SiteId, SpecificCostId, RcptNbr
GO
