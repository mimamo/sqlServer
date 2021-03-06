USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabDet_uWTR]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJLabDet_uWTR]
	@ParmAction varchar(1), @ParmBillable varchar(1), @ParmUserID varchar(47), 
		@ParmDocNbr varchar(10), @ParmLineNbr varchar(30) AS
Exec("
	UPDATE PJLabDet
		SET ld_id17 = '" + @ParmAction + "'
			, ld_status = '" + @ParmBillable + "'
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		WHERE docnbr = '" + @ParmDocNbr + "'
			AND linenbr = '" + @ParmLineNbr + "'
")
GO
