USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_1099]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_1099    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor_1099] @parm1 varchar ( 15) As
Select * from Vendor where VendID like @parm1 and
Vend1099 = 1 order by VendID
GO
