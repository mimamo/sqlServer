USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ProcErrLog_Ins]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ProcErrLog_Ins]
	@Crtd_Prog		char(8),
	@Crtd_User		char(10),
 	@ExecString		varchar(255),
	@WError			int
AS
SET NOCOUNT ON
DECLARE @ErrMsg	varchar(510)

	IF @WError < 50000
	BEGIN
		IF @WError = 0
		SELECT @ErrMsg = 'OKAY'
		ELSE
		SELECT @ErrMsg = RTRIM(description) FROM  master.dbo.sysmessages where Error = @WError
	END
	ELSE
	BEGIN
		SELECT @ErrMsg = ''
	END
	INSERT 	INTO ProcErrLog
		(Crtd_Prog, Crtd_User, ErrDesc, ErrNo, ExecString, SortKey)
	SELECT	@Crtd_Prog, @Crtd_User, @ErrMsg, @WError, @ExecString, ISNULL(MAX(SortKey), 0) + 1
	FROM  	ProcErrLog
	RETURN 1	--ERROR ENCOUNTER
GO
