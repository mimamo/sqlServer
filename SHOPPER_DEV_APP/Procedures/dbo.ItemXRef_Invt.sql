USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_Invt]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemXRef_Invt  Script Date: 9/14/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.ItemXRef_Invt Script Date: 9/14/98 7:41:52 PM ******/
Create Proc [dbo].[ItemXRef_Invt] @parm1 varchar ( 30) as
Select * from ItemXRef where Invtid = @parm1
  Order by AltIDType
GO
