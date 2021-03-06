USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjproj_sweb_PV]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjproj_sweb_PV] 
	@Parm0 varchar(16),@Parm1 varchar(10), @Parm2 varchar(10), @SortCol varchar(60) AS

	DECLARE @ProjCaption char(16)
	Select @ProjCaption=ltrim(substring(control_data,2,16)) from PJContrl 
		where control_type = 'FK' and control_code = 'PROJECT'

exec("
	Select '" + @ProjCaption + "'=rtrim(P.Project), 'Description'=P.Project_Desc, 
		'Status'=P.Status_PA, 'Customer ID'=P.Customer, 'Customer Name'=C.Name 
	from PJProj P, CUSTOMER C 
	where Project like '%" + @Parm0 + "%'
		 and P.Customer *= C.CustId
	Order by " + @SortCol   
)
GO
