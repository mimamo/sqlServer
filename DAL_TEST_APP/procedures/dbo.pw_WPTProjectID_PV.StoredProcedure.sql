USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_WPTProjectID_PV]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_WPTProjectID_PV] 

	@Parm0 varchar(16), @Parm1 varchar(10), @ParmEmployee varchar(10), @SortCol varchar(60) AS

	DECLARE @ProjCaption char(16)

	Select @ProjCaption=ltrim(substring(control_data,2,16)) from PJContrl 
		where control_type = 'FK' and control_code = 'PROJECT'

	exec("

	Select '" + @ProjCaption + "'=rtrim(P.Project), 'Description'=P.Project_Desc, 
		'Customer ID'=P.Customer, 'Customer Name'=C.Name 
	from PJProj P, CUSTOMER C, PJPROJEM E 
	where   
        P.project = E.project and 
          (E.employee = '" + @ParmEmployee + "' or E.employee = '*')  
        and P.Project like '%" + @Parm0 + "%'
		and P.Status_PA = 'A' and P.Status_LB = 'A' and P.Customer *= C.CustId
	Order by " + @SortCol  
	)
GO
