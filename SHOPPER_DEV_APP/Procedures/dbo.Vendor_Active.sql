USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_Active]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_Active    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor_Active] @parm1 varchar ( 15) As
Select * from Vendor Where Status <> 'H' and VendId Like @parm1
Order By VendId
GO
