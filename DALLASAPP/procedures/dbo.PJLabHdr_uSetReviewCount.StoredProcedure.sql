USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabHdr_uSetReviewCount]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLabHdr_uSetReviewCount]
	@ParmUserID varchar(47), @ParmDocNbr varchar(10) AS
Exec("
	UPDATE PJLabHdr
		SET le_id07 = 
			(select count(*) from PJLABDET 
				where docnbr = '" + @ParmDocNbr + "'
					and (ld_id17 = '1' or ld_id17 = 'R'))
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		Where docnbr = '" + @ParmDocNbr + "'
")
GO
