USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smLBDetail_ServiceCallID]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smLBDetail_ServiceCallID]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smLBDetail
	left outer join Inventory
		on smLBDetail.InvtId = Inventory.InvtId
WHERE ServiceCallID = @parm1
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY ServiceCallID
	,LineNbr
GO
