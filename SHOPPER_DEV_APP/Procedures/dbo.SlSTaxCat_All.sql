USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlSTaxCat_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlSTaxCat_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[SlSTaxCat_All] @parm1 varchar ( 10) As
     Select * from SlsTaxCat
     where CatId like @parm1 order by CatID
GO
