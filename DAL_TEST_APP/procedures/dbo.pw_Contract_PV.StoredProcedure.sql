USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_Contract_PV]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_Contract_PV] 
	@Parm0 varchar(16), @Parm1 varchar(10), @ParmEmployee varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Contract'=rtrim(C.Contract), 'Description'=C.Contract_desc, 'Customer'=U.Name
	from PJCont C, Customer U
	where Contract like '%" + @Parm0 + "%'
	and C.Customer = U.CustID
	Order by " + @SortCol  
)
GO
