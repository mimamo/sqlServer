USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_Name]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Vendor_Name] @Parm1 varchar (30) as
	Select Name from Vendor where VendId = @parm1
GO
