USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJDeleteTimecardLine]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJDeleteTimecardLine]
	@DocNbr varchar(10),
	@LineNbr int AS

BEGIN TRANSACTION

	DECLARE @mm char(2), @dd char(2), @yyyy char(4), @EmpID varchar(10), @PE_Date smalldatetime
	DECLARE @Project char(16), @PJT_Entity char(32), @LD_ID08 datetime

	Select @EmpID=Employee, @PE_Date=PE_date from PJLABHDR where DocNbr=@DocNbr
	IF @@ERROR <> 0 GOTO ABORT

	Select @mm=right("00" + ltrim(rtrim(str(datepart(month,@PE_Date)))),2)
	Select @dd=right("00" + ltrim(rtrim(str(datepart(day,@PE_Date)))),2)
	Select @yyyy=ltrim(rtrim(str(datepart(year,@PE_Date))))

	Select @Project=Project , @PJT_Entity=PJT_Entity, @LD_ID08=ld_id08
		from PJLABDET where DocNbr=@DocNbr and Linenbr = @LineNbr
	IF @@ERROR <> 0 GOTO ABORT

	DELETE FROM PJNOTES
		WHERE Note_Type_Cd = "TCIC" 
		and key_value = rtrim(@Project) + " " + rtrim(@PJT_Entity) + " " +rtrim(@EmpID) + " " + @yyyy + @mm + @dd
	IF @@ERROR <> 0 GOTO ABORT

	Select @mm=right("00" + ltrim(rtrim(str(datepart(month,@LD_ID08)))),2)
	Select @dd=right("00" + ltrim(rtrim(str(datepart(day,@LD_ID08)))),2)
	Select @yyyy=ltrim(rtrim(str(datepart(year,@LD_ID08))))

	DELETE FROM PJNOTES
		WHERE Note_Type_Cd = "TCIC" 
		and key_value = rtrim(@Project) + " " + rtrim(@PJT_Entity) + " " +rtrim(@EmpID) + " " + @yyyy + @mm + @dd
	IF @@ERROR <> 0 GOTO ABORT

	DELETE FROM pjlabdet where DocNbr = @DocNbr and LineNbr = @LineNbr
	IF @@ERROR <> 0 GOTO ABORT

	Exec PJLabHdr_uSetReviewCount @EmpID, @DocNbr

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
