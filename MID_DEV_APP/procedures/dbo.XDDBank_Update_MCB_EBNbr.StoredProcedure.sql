USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_Update_MCB_EBNbr]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_Update_MCB_EBNbr]
	@Acct		varchar( 10 ),
	@Sub		varchar( 24 ),
	@EBNbrPrefix	varchar( 2 ),
	@NextEBNbr	varchar( 10 ),
	@EBNbrLen	smallint
AS
	UPDATE		XDDBank
	SET		MCB_EBNbrLen = @EBNbrLen,
			MCB_EBNbrPrefix = @EBNbrPrefix,
			MCB_NextEBNbr = @NextEBNbr
	WHERE		Acct = @Acct
			and Sub = @Sub
GO
