USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_Active]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_Active    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor_Active] @parm1 varchar ( 15) As
Select * from Vendor Where Status <> 'H' and VendId Like @parm1
Order By VendId
GO
