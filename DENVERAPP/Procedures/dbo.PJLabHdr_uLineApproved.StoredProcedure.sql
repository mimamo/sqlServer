USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabHdr_uLineApproved]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLabHdr_uLineApproved]
	@ParmUserID varchar(47), @ParmDocNbr varchar(10) AS
Exec("
	UPDATE PJLabHdr
		SET le_id07 = 
			CASE WHEN le_id07 > 0 
				THEN le_id07 - 1 
				ELSE 0 
			END
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		WHERE docnbr = '" + @ParmDocNbr + "'
")
GO
