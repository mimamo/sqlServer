USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TDS_BatchARDocARTran]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE	PROCEDURE [dbo].[TDS_BatchARDocARTran] @UserID CHAR(10), @Screen CHAR(5), @BatNbr CHAR(10) AS

UPDATE	Batch SET
	Crtd_DateTime=CASE Crtd_User WHEN '' THEN GETDATE() ELSE Crtd_DateTime END,
	Crtd_User=CASE Crtd_User WHEN '' THEN @UserID ELSE Crtd_User END,
	Crtd_Prog=CASE Crtd_User WHEN '' THEN @Screen ELSE Crtd_Prog END,
	Lupd_DateTime=GETDATE(),
	Lupd_User=@UserID,
	Lupd_Prog=@Screen
WHERE	Module='AR' AND BatNbr=@BatNbr AND Lupd_User=''

UPDATE	ARDoc SET
	Crtd_DateTime=CASE Crtd_User WHEN '' THEN GETDATE() ELSE Crtd_DateTime END,
	Crtd_User=CASE Crtd_User WHEN '' THEN @UserID ELSE Crtd_User END,
	Crtd_Prog=CASE Crtd_User WHEN '' THEN @Screen ELSE Crtd_Prog END,
	Lupd_DateTime=GETDATE(),
	Lupd_User=@UserID,
	Lupd_Prog=@Screen
WHERE	BatNbr=@BatNbr AND Lupd_User=''

UPDATE	ARTran SET
	Crtd_DateTime=CASE Crtd_User WHEN '' THEN GETDATE() ELSE Crtd_DateTime END,
	Crtd_User=CASE Crtd_User WHEN '' THEN @UserID ELSE Crtd_User END,
	Crtd_Prog=CASE Crtd_User WHEN '' THEN @Screen ELSE Crtd_Prog END,
	Lupd_DateTime=GETDATE(),
	Lupd_User=@UserID,
	Lupd_Prog=@Screen
WHERE	BatNbr=@BatNbr AND Lupd_User=''
GO
