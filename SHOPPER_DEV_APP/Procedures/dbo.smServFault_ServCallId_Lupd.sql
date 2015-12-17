USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_ServCallId_Lupd]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServFault_ServCallId_Lupd]
		@parm1	varchar(10),
		@parm2	smallint,
		@parm3	datetime
AS
	SELECT
		*
	FROM
		smServFault
	WHERE
		ServiceCallId = @parm1
		AND LineNbr = @parm2
--		AND Lupd_DateTime <= @parm3
		AND CONVERT(DATETIME,SF_ID03)  <= @parm3
	ORDER BY
		ServiceCallId
		,LineNbr
GO
