USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCSpecialDetail_CommSpecId]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smCSpecialDetail_CommSpecId]
	@parm1 varchar(24)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smCSpecialDetail
	left outer join Inventory
		on smCSpecialDetail.InvtID = Inventory.InvtId
WHERE CommSpecId = @parm1
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY CommSpecId, LineNbr
GO
