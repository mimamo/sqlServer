USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_DoesEmployeeExist]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJEMPLOY_DoesEmployeeExist]
	@Employee char(10),
	@EmployeeExistFlag bit OUTPUT
	
AS
	begin

	-- Check if the employee passed in is found.  Set flag accordingly
	if exists(select * from PJEmploy where Employee = @Employee)
		select @EmployeeExistFlag = 1
	else
		select @EmployeeExistFlag = 0

	end
GO
