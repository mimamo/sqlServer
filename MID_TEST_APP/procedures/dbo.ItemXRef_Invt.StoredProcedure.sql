USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_Invt]    Script Date: 12/21/2015 15:49:23 ******/
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
