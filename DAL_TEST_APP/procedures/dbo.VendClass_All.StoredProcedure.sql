USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendClass_All]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.VendClass_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Proc [dbo].[VendClass_All] @parm1 varchar (10) as
    Select * from VendClass where ClassId like @parm1 order by ClassId
GO
