USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_GetActiveJobsByUserClientProductJob_PV]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[pw_GetActiveJobsByUserClientProductJob_PV] 

	@ParmUser varchar(10), @ParmClient varchar(15), @ParmProduct varchar(4), @ParmJob varchar(16), @SortCol varchar(60)  AS

	DECLARE @ProjCaption char(16)

	Select @ProjCaption=ltrim(substring(control_data,2,16)) from PJContrl 
		where control_type = 'FK' and control_code = 'PROJECT'

	exec("

	--CyGen - CG - 8-10-06 - on the next line and a few lines down I replaced the P.Customer field with the P.pm_id01 field
	--because they do not always match, and Manny said that we should be using the pm_id01 value for the customer id, this appears
	--to be due to a customization that was made by Alterra for Integer since Integer's client and billable customer for a single job
	--can be different
	Select '" + @ProjCaption + "'=rtrim(P.Project), 'Description'=P.Project_Desc, 'Client ID'=P.pm_id01, 'Client Name'=C.Name 
	from PJProj P, CUSTOMER C, PJPROJEM E
	where   
        P.project = E.project and 
          (E.employee = '" + @ParmUser + "' or E.employee = '*')  
        and P.Project like '%" + @ParmJob + "%'
		
		and P.Status_PA = 'A' and P.Status_LB = 'A' and P.pm_id01 *= C.CustId and P.pm_id01 like '%" + @ParmClient + "%' and P.pm_id02 like '%" + @ParmProduct + "%'
	Order by " + @SortCol  
	)
GO
