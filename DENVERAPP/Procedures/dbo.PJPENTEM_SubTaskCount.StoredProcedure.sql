USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEM_SubTaskCount]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJPENTEM_SubTaskCount] @project varchar (16), @task varchar (32), @employee varchar (10) as
declare @BlankFound int	

if (select count(*) from pjpentem where	project = @project and pjt_entity = @task and employee = @employee ) > 0
		--Records exist for this Project, Task, Employee.  Now check for blank subtask.	
	Begin
		if (select count(*) from pjpentem where	project = @project and pjt_entity = @task and employee = @employee and subtask_name = '' ) > 0
			--Blank Subtask found
			Begin
				set @BlankFound = 1
			End
		else
			--No blank subtasks.  All non-blank.  Subtask must be required!
			Begin
				set @BlankFound = 0
			End
	End
else
	--No pjpentem records found
	Begin
		set @BlankFound = 9
	End
--Return value 
select @BlankFound
GO
