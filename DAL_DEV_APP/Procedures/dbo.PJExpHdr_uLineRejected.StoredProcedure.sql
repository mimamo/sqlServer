USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJExpHdr_uLineRejected]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJExpHdr_uLineRejected]
	@ParmUserID varchar(47), @ParmDocNbr varchar(10) AS
Exec("
	UPDATE PJExpHdr
		SET status_1 = 'R'
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		WHERE docnbr = '" + @ParmDocNbr + "'
")

SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON
GO
