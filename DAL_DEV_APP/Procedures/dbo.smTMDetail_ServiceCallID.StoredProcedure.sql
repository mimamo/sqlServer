USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smTMDetail_ServiceCallID]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smTMDetail_ServiceCallID]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smTMDetail
	left outer join Inventory
		on smTMDetail.InvtId = Inventory.InvtId
WHERE ServiceCallID = @parm1
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY ServiceCallID
	,LineNbr
GO
