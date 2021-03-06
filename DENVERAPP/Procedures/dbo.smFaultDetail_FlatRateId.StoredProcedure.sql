USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smFaultDetail_FlatRateId]    Script Date: 12/21/2015 15:43:10 ******/
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
