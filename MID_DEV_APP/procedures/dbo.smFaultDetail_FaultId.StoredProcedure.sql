USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smFaultDetail_FaultId]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smFaultDetail_FaultId]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smFaultDetail
	left outer join smFlatRate
		on smFaultDetail.FlatRateId = smFlatRate.FlatRateId
WHERE FaultId = @parm1
	AND smFaultDetail.FlatRateId LIKE @parm2
ORDER BY smFaultDetail.FaultId
	,smFaultDetail.FlatRateId
GO
