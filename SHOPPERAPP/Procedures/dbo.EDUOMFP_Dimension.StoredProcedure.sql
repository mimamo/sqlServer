USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDUOMFP_Dimension]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDUOMFP_Dimension] @Dimension varchar(3), @UOM varchar(6) As
Select * From EDUOMFP Where Dimension = @Dimension And UOM Like @UOM Order By Dimension, UOM
GO
