USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_Vendor_PV]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pw_Vendor_PV] 
	@Parm0 varchar(16),@Parm1 varchar(10), @Parm2 varchar(10), @SortCol varchar(60) AS
exec("
	Select 'Vendor ID'=rtrim(vendor.vendid) , 'Name'=vendor.name
	from vendor
	where vendID like '%" + @Parm0 + "%'
	Order by " + @SortCol  
)
GO
