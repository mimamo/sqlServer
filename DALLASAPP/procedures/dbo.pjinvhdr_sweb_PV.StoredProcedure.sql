USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sweb_PV]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_sweb_PV] 
	@Parm0 varchar(10), @Parm1 varchar(16), @Parm2 varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Draft#'=draft_num, 'Invoice#'=invoice_num, 'Invoice Date'=invoice_date, 
		'Status'=inv_Status, 'Customer ID'=Customer, 'Amount'=gross_amt 
	from PJinvhdr 
	where draft_num like '%" + @Parm0 + "%'
		 and project_billwith = '" + @Parm1 + "'
	Order by " + @SortCol   
)
GO
