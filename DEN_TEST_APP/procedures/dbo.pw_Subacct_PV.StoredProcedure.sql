USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_Subacct_PV]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_Subacct_PV] 
	@Parm0 varchar(16), @Parm1 varchar(10), @ParmEmployee varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Subaccount'=rtrim(S.Sub) , 'Description'=S.Descr
	from Subacct S 
	where Sub like '%" + @Parm0 + "%'
		and S.Active = 1
	Order by " + @SortCol  
)
GO
