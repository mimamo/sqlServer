USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_invt_no_serialU]    Script Date: 12/21/2015 14:06:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create PROCEDURE [dbo].[sm_invt_no_serialU]
	@parm1	varchar(30)
AS
	SELECT
		*
	FROM
		inventory
	WHERE
		invtid LIKE @parm1
		AND
		SerAssign <> 'U'

	ORDER BY
		invtid
GO
