USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDUOMFP_Dimension]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDUOMFP_Dimension] @Dimension varchar(3), @UOM varchar(6) As
Select * From EDUOMFP Where Dimension = @Dimension And UOM Like @UOM Order By Dimension, UOM
GO
