USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[sm_invt_no_lotserial]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sm_invt_no_lotserial]
	@parm1	varchar(30)
AS
	SELECT
		*
	FROM
		inventory
	WHERE
		invtid LIKE @parm1
		AND
		(StkItem = 0 OR LotSerTrack = 'NN')
	ORDER BY
		invtid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
