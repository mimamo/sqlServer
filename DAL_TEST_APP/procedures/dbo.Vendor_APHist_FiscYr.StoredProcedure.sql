USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_APHist_FiscYr]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Vendor_APHist_FiscYr] @parm1 varchar ( 15), @parm2 varchar ( 4) as
Select *
from Vendor
	left outer join APHist
		on Vendor.VendId = APHist.VendId
where Vendor.VendId = @parm1 and
	(APHist.FiscYr = @parm2 or APHist.FiscYr = '')
Order by Vendor.VendId
GO
