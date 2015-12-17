USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServUsage_ServCallId]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServUsage_ServCallId]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smServUsage
	left outer join smEqUsage
		on smServUsage.UsageID = smEqUsage.UsageID
WHERE ServiceCallId = @parm1
	AND smServUsage.UsageID LIKE @parm2
ORDER BY smServUsage.ServiceCallId
	,smServUsage.UsageID
GO
