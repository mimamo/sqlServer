USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEMXREFMSP_spk0]    Script Date: 12/21/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEMXREFMSP_spk0] @project varchar (16), @task varchar (32) , @employee varchar (10), @subtask varchar (50)   as
select	PJPENTEMXREFMSP.Assignment_MSPID
From	PJPENTEMXREFMSP
where	PJPENTEMXREFMSP.project         =    @project
and		PJPENTEMXREFMSP.pjt_entity      =	 @task
and		PJPENTEMXREFMSP.employee        =	 @employee
and		PJPENTEMXREFMSP.subtask_name    =	 @subtask
GO
