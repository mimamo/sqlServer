USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor_ClassId]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor_ClassId    Script Date: 4/7/98 12:19:55 PM ******/
Create Proc [dbo].[Vendor_ClassId] @parm1 varchar ( 10) as
    Select * from Vendor where ClassId = @parm1 order by Vendid
GO
