USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pw_Customer_PV]    Script Date: 12/21/2015 15:43:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_Customer_PV] 
	@Parm0 varchar(16), @Parm1 varchar(10), @ParmEmployee varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Customer ID'=rtrim(C.CustID) , 'Name'=C.Name
	from Customer C
	where CustID like '%" + @Parm0 + "%'
	Order by " + @SortCol  
)
GO
