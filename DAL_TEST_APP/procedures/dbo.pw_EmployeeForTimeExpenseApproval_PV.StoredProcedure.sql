USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_EmployeeForTimeExpenseApproval_PV]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_EmployeeForTimeExpenseApproval_PV] 
	@Parm0 varchar(16),@Parm1 varchar(10), @Parm2 varchar(10), @SortCol varchar(60), @Approver varchar(10) AS

	SET NOCOUNT ON

	--Create a temp table to hold expense reports and the number of line items they have for the employee passed in
	CREATE TABLE #EmployeeList( Employee CHAR(10) , Emp_name char(40))

	--Get the employee awaiting timecard approval from the @Approver passed in
	INSERT INTO #EmployeeList		
	SELECT e.Employee, e.Emp_name from PJLABHDR lh
	JOIN PjEmploy e ON lh.Employee = e.Employee 
	where lh.Approver = @Approver
	and lh.le_status = 'C'
	and lh.le_id07 = 0

	--Get the employee awaiting expense approval from the @Approver passed in
	INSERT INTO #EmployeeList		
	SELECT e.Employee, e.Emp_name from PJEXPHDR eh
	JOIN PjEmploy e ON eh.Employee = e.Employee 
	where eh.Approver = @Approver
	and eh.status_1 = 'C'
	and eh.te_id06 = 0

	--Get a distinct list of employees that have Time/Expense documents awaiting approval
	exec('
		Select distinct ''Employee ID''=rtrim(E.Employee) , Name=E.Emp_name 
		from #EmployeeList E 
		where Employee like ''%' + @Parm0 + '%''
		Order by ' + @SortCol
	)

	DROP TABLE #EmployeeList
GO
