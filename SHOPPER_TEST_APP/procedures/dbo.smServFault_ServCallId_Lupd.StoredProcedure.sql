USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_ServCallId_Lupd]    Script Date: 12/21/2015 16:07:21 ******/
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
