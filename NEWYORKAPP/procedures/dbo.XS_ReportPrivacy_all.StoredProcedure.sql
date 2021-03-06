USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XS_ReportPrivacy_all]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XS_ReportPrivacy_all]
	@parm1 varchar( 5 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM XS_ReportPrivacy
	WHERE ReportNbr LIKE @parm1
	   AND ReportFormat LIKE @parm2
	ORDER BY ReportNbr,
	   ReportFormat
GO
