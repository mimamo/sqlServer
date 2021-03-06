USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRateDetail_FlatRateId]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smRateDetail_FlatRateId]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smRateDetail
	left outer join Inventory
		on smRateDetail.InvtId = Inventory.InvtId
WHERE FlatRateId = @parm1
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY FlatRateId
	,LineNbr
GO
