USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEBFile_EffDate_Update_MCB]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEBFile_EffDate_Update_MCB]
	@BatNbr		varchar( 10 ),
	@EffDate		smalldatetime,
	@Prog		varchar( 8 ),
	@User		varchar( 10 )

AS

	Declare	@CurrDate 	smalldatetime

	SELECT	@CurrDate = cast(convert(varchar(10), getdate(), 101) as smalldatetime)

	UPDATE	APDoc
	SET		DocDate = @EffDate,
			LUpd_Prog = @Prog,
			LUpd_User = @User,
			LUpd_DateTime = @CurrDate
	WHERE 	BatNbr = @BatNbr

	UPDATE	APTran
	SET		TranDate = @EffDate,
			LUpd_Prog = @Prog,
			LUpd_User = @User,
			LUpd_DateTime = @CurrDate
	WHERE 	BatNbr = @BatNbr
GO
