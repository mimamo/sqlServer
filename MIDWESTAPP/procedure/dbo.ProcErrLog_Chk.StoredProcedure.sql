USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ProcErrLog_Chk]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcErrLog_Chk]
	@Crtd_Prog		char(8),
	@Crtd_User		char(10)
AS
SET NOCOUNT ON

	SELECT 	Crtd_Prog, Crtd_User, RTRIM(ExecString), ErrNo, RTRIM(ErrDesc)
	FROM 	ProcErrLog
	WHERE 	Crtd_Prog = @Crtd_Prog AND Crtd_User = @Crtd_User
	ORDER 	BY Crtd_User, Crtd_Prog, SortKey DESC
GO
