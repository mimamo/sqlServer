USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJExpDet_uWTR]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJExpDet_uWTR]
	@ParmAction varchar(1), @ParmBillable varchar(1), @ParmUserID varchar(47), 
		@ParmDocNbr varchar(10), @ParmLineNbr varchar(30) AS
Exec("
	UPDATE PJExpDet
		SET td_id14 = '" + @ParmAction + "'
			, status = '" + @ParmBillable + "'
			, lupd_user = '" + @ParmUserID + "'
			, lupd_datetime = CURRENT_TIMESTAMP
			, lupd_prog = 'TMWTR00'
		WHERE docnbr = '" + @ParmDocNbr + "'
			AND linenbr = '" + @ParmLineNbr + "'
")
GO
