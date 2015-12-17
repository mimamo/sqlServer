USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProcErrLog_Del]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcErrLog_Del]
	@Crtd_Prog		char(8),
	@Crtd_User		char(10)
AS
SET NOCOUNT ON
	DELETE 	ProcErrLog
	WHERE 	Crtd_Prog = @Crtd_Prog AND Crtd_User = @Crtd_User
	RETURN 0	--NO ERROR ENCOUNTERED
GO
