USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPLOY_GetDefaultApprover]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPLOY_GetDefaultApprover]	@Employee varchar (10),
						@Role char(1),
						@OtherEmp varchar(10)
as

	SET NOCOUNT ON

	/* if the role to use is a supervisor 'S' */
	IF(@Role = 'S')
	BEGIN
		select 
		ApproverID = case
				when e2.employee is null then ''
				else e2.employee
			     end,
		ApproverName = case
				when e2.emp_name is null then ''
				else e2.emp_name
			     end,
                e2.exp_approval_max 
		from PJEmploy e1
		left join PJEmploy e2 on e1.manager1 = e2.employee
		where e1.employee = @Employee

	END

	/* if the role to use is a manager 'M' */
	IF(@Role = 'M')
	BEGIN
		select 
		ApproverID = case
				when e2.employee is null then ''
				else e2.employee
			     end,
		ApproverName = case
				when e2.emp_name is null then ''
				else e2.emp_name
			     end,
		e2.exp_approval_max
		from PJEmploy e1
		left join PJEmploy e2 on e1.manager2 = e2.employee
		where e1.employee = @Employee
	END


	/* if the employee to use is one specified in the FLEX_APPROVAL row in the control table */
	IF(@Role = 'O')
	BEGIN
		select employee ApproverID, emp_name ApproverName, exp_approval_max
		from PJEmploy e
		where employee = @OtherEmp
	END
GO
