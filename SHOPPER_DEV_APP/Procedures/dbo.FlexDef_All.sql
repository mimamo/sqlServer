USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FlexDef_All]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FlexDef_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[FlexDef_All] @parm1 varchar ( 15) as
       Select * from FlexDef where FieldClassName like @parm1
                              order by FieldClassName
GO
