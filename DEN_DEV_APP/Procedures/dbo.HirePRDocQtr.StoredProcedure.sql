USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[HirePRDocQtr]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[HirePRDocQtr]
	@Employee as char(10),
	@Year as char(4),
	@Cpny as char(10)
as
	Select MIN(CalQtr)
	From PRDoc
	Where CalYr = @Year
		and EmpId = @Employee
		and Rlsed = 1
		and Status <> 'V'
		and CpnyID = @Cpny
		and S4Future10 = 1
GO
