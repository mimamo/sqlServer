USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pw_EmployeeForTimeExpenseApprovalCount_PV]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_EmployeeForTimeExpenseApprovalCount_PV] 
	@Approver varchar(10), @Parm0 varchar(16) AS

	SET NOCOUNT ON
	--Create a temp table to hold expense reports and the number of line items they have for the employee passed in
	CREATE TABLE #EmployeeList( Employee CHAR(10) , Emp_name char(40), SecurityFlag char(4))

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
	Select Count(distinct Employee) iCount
	from #EmployeeList 

	DROP TABLE #EmployeeList
GO
