USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_ExpType_PV]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_ExpType_PV] 
	@Parm0 varchar(30), @Parm1 varchar(1), @ParmEmployee varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Expense Type'=exp_type , Description=desc_exp 
	from PJEXPTYP 
	where exp_type like '%" + @Parm0 + "%'
	Order by " + @SortCol  
)
GO
