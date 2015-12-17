USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConMaster_CpnyID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smConMaster_CpnyID]
		 @parm1 varchar(10)
		,@parm2 varchar(10)

AS
	SELECT
		*
	FROM
		smConMaster
	WHERE
		EXISTS (SELECT * FROM smBranch WHERE CpnyID = @parm1 AND branchid = smConmaster.Branchid)
			AND
		MasterId LIKE @parm2
	ORDER BY
		CustID
		,MasterId
GO
