USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_All]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor_All] @parm1 varchar ( 15) as
Select * from Vendor where VendId like @parm1 order by VendId
GO
