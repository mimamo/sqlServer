USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_AcctCat_PV]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_AcctCat_PV] 
	@Parm0 varchar(30),@Parm1 varchar(1), @Parm2 varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Account Cat'=acct , Description=acct_desc  
	from PJACCT
	where acct like '%" + @Parm0 + "%'
	Order by " + @SortCol  
)
GO
