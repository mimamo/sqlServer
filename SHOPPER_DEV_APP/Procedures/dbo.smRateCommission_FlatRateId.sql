USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRateCommission_FlatRateId]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smRateCommission_FlatRateId]
	@parm1 varchar(10)
	,@parm2beg smallint
	,@parm2end smallint
AS
SELECT *
FROM smRateCommission
	left outer join smCommType
		on smRateCommission.CommTypeId = smCommType.CommTypeId
WHERE flatRateId = @parm1
	AND LineNbr BETWEEN @parm2beg AND @parm2end
ORDER BY FlatRateId
	,LineNbr
GO
