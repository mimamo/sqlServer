USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_EmployeeALL_PV]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_EmployeeALL_PV] 
	@Parm0 varchar(16),@Parm1 varchar(10), @Parm2 varchar(10), @SortCol varchar(60) AS
exec('
	Select ''Employee ID''=rtrim(E.Employee) , Name=E.Emp_name 
	from PJEmploy E 
	where Employee like ''%' + @Parm0 + '%''
	Order by ' + @SortCol
)
GO
