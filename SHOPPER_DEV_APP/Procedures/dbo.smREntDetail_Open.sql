USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smREntDetail_Open]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smREntDetail_Open]
	@parm1 varchar(10)
	,@parm2 varchar(10)
	,@parm3Min smallint
	,@parm3max smallint
AS
SELECT *
FROM smRentDetail
	left outer join smRentHeader
		on smREntDetail.TransId = smRentHeader.TransId
WHERE smREntDetail.EquipID = @Parm1
	AND smREntDetail.TransID LIKE @parm2
	AND smREntDetail.LineID BETWEEN @parm3min AND @parm3Max
	AND smRentHEader.Status IN ('R','N','P')
ORDER BY	smREntDetail.EquipID
	,smREntDetail.StartDate DESC
	,smRentDetail.LineId DESC
GO
