USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smREntDetail_All_Trans]    Script Date: 12/21/2015 13:35:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smREntDetail_All_Trans]
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
ORDER BY smREntDetail.EquipID
	,smRentDetail.TransID DESC
	,smREntDetail.StartDate DESC
	,smRentDetail.LineId DESC
GO
