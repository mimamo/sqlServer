USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendClass_All]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.VendClass_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Proc [dbo].[VendClass_All] @parm1 varchar (10) as
    Select * from VendClass where ClassId like @parm1 order by ClassId
GO
