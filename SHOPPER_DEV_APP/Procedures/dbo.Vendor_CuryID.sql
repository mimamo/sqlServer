USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_CuryID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor_CuryID]  @parm1 varchar ( 4), @parm2 varchar ( 15) as
Select * from Vendor where (Vendor.CuryID = "" or Vendor.CuryID =@parm1) and VendId like @parm2 order by VendId
GO
