USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabHdr_uLineRejected]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLabHdr_uLineRejected]
	@ParmUserID varchar(47), @ParmDocNbr varchar(10) AS
Exec("
	UPDATE PJLabHdr
		SET le_status = 'R'
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		WHERE docnbr = '" + @ParmDocNbr + "'
")
GO
