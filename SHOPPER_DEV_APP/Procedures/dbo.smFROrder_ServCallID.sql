USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smFROrder_ServCallID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smFROrder_ServCallID]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smFROrder
	left outer join smFlatRate
		on smFROrder.FlatRateID = smFlatRate.FlatRateId
	,smPlan
WHERE ServCallID = @parm1
	AND smFROrder.PlanID = smPlan.PlanID
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY ServCallID, LineNbr
GO
