USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_ContractID]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_ContractID]
		@parm1	varchar(10)
	       ,@parm2  varchar(10)
AS
	SELECT
		*
	FROM
		smServCall (NOLOCK)
	WHERE
		ContractID = @parm1
			AND
		ServiceCallID LIKE @parm2
	ORDER BY
		ServiceCallId
GO
