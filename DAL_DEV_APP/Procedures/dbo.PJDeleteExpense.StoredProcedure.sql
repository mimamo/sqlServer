USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDeleteExpense]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PJDeleteExpense]
	@DocNbr varchar(10) as

BEGIN TRANSACTION

	DECLARE @EmpID varchar(10)

	Select *  from PJEXPHDR where DocNbr=@DocNbr
	IF @@ERROR <> 0 GOTO ABORT

	DELETE FROM PJNOTES
	WHERE Note_Type_Cd = "TEEX" and key_value = RTrim(@DocNbr) 
	IF @@ERROR <> 0 GOTO ABORT


	DELETE FROM PJEXPHDR where DocNbr = @DocNbr
	IF @@ERROR <> 0 GOTO ABORT

	DELETE FROM PJEXPDET where DocNbr = @DocNbr
	IF @@ERROR <> 0 GOTO ABORT

COMMIT TRANSACTION
--Select @RetCode=0  --successful
RETURN 0
GOTO FINISH

ABORT:
ROLLBACK TRANSACTION
RETURN 1
--Select @RetCode=1  --failed

FINISH:
GO
