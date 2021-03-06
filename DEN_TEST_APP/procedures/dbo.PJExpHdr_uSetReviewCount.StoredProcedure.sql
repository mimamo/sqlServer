USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJExpHdr_uSetReviewCount]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJExpHdr_uSetReviewCount]
	@ParmUserID varchar(47), @ParmDocNbr varchar(10) AS
Exec("
	UPDATE PJExpHdr
		SET te_id06 = 
			(select count(*) from PJEXPDET 
				where docnbr = '" + @ParmDocNbr + "'
					and (td_id14 = '1' or td_id14 = 'R'))
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		Where docnbr = '" + @ParmDocNbr + "'
")
GO
