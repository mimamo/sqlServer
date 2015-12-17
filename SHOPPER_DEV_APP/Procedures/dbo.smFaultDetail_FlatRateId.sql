USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smFaultDetail_FlatRateId]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smFaultDetail_FlatRateId]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smFaultDetail
	left outer join smCode
		on smFaultDetail.FaultId = smCode.Fault_Id
WHERE smFaultDetail.FlatRateId = @parm1
	AND smFaultDetail.FaultId LIKE @parm2
ORDER BY smFaultDetail.FlatRateId
	,smFaultDetail.FaultId
GO
