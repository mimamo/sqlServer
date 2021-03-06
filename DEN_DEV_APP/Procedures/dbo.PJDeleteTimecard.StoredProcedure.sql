USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJDeleteTimecard]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJDeleteTimecard]
	@DocNbr varchar(10) as

BEGIN TRANSACTION

	DECLARE @mm char(2), @dd char(2), @yyyy char(4), @EmpID varchar(10), @PE_Date smalldatetime

	Select @EmpID=Employee, @PE_Date=PE_date from PJLABHDR where DocNbr=@DocNbr
	IF @@ERROR <> 0 GOTO ABORT

	Select @mm=right("00" + ltrim(rtrim(str(datepart(month,@PE_Date)))),2)
	Select @dd=right("00" + ltrim(rtrim(str(datepart(day,@PE_Date)))),2)
	Select @yyyy=ltrim(rtrim(str(datepart(year,@PE_Date))))

	DELETE FROM PJNOTES
	WHERE Note_Type_Cd = "TIME" and key_value = RTrim(@EmpID) + " " + @mm + @dd + @yyyy
	IF @@ERROR <> 0 GOTO ABORT

	DELETE FROM PJNOTES
	WHERE Note_Type_Cd = "TCIC" and key_value in
		(select Rtrim(project) + " " + rtrim(pjt_entity) 
			+ " " + rtrim(@EmpID) + " " +  
			ltrim(rtrim(str(datepart(year,LD_ID08)))) +
			right("00" + ltrim(rtrim(str(datepart(month,@PE_Date)))),2) +
			right("00" + ltrim(rtrim(str(datepart(day,@PE_Date)))),2)
			from pjlabdet 
			where Docnbr = @DocNbr)

	DELETE FROM PJNOTES
	WHERE Note_Type_Cd = "TCIC" and key_value in
		(select Rtrim(project) + " " + rtrim(pjt_entity) 
			+ " " + rtrim(@EmpID) + " " +  @yyyy + @mm + @dd
			from pjlabdet 
			where Docnbr = @DocNbr)

	IF @@ERROR <> 0 GOTO ABORT

	DELETE FROM pjlabhdr where DocNbr = @DocNbr
	IF @@ERROR <> 0 GOTO ABORT

	DELETE FROM pjlabdet where DocNbr = @DocNbr
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
