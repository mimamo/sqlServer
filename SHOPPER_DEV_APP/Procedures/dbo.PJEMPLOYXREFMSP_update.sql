USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOYXREFMSP_update]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOYXREFMSP_update] 
	@Employee			char(10),
	@Employee_MSPName	Char(60),		
	@ProjectManager		char(1),
	@WindowsUserAcct	char(85),
	@lupd_user			char(8),
	@lupd_prog			char(6)
as	
	Update PJEMPLOYXREFMSP 
		set Employee_MSPName = @Employee_MSPName, 
			ProjectManager = @ProjectManager, 
			WindowsUserAcct =  @WindowsUserAcct, 
			lupd_datetime = getdate(),
			lupd_user = @lupd_user,
			lupd_prog = @lupd_prog
	WHERE Employee = @Employee
GO
