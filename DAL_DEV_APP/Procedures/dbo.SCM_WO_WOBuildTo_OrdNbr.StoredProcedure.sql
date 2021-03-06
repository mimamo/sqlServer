USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_WO_WOBuildTo_OrdNbr]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SCM_WO_WOBuildTo_OrdNbr]
	@WONbr		varchar ( 16 ),
	@OrdNbr		varchar ( 15 ),
	@LineRef	varchar ( 5 )
AS
	SELECT		*
	FROM		WOBuildTo B LEFT OUTER JOIN WOHeader H
			On H.WONbr = B.WONbr
	WHERE		B.WONbr = @WONbr and
			B.Status = 'P' and		-- Planned Target only
			B.OrdNbr = @OrdNbr and
			B.BuildToLineRef = @LineRef
GO
