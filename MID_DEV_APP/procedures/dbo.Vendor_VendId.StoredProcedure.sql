USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_VendId]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_VendId    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor_VendId] @parm1 varchar ( 15) as
Select * from Vendor where VendId = @parm1
GO
