USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJExpHdr_uLineApproved]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJExpHdr_uLineApproved]
	@ParmUserID varchar(47), @ParmDocNbr varchar(10) AS
Exec("
	UPDATE PJExpHdr
		SET te_id06 = 
			CASE WHEN te_id06 > 0 
				THEN te_id06 - 1 
				ELSE 0 
			END
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		WHERE docnbr = '" + @ParmDocNbr + "'
")
GO
