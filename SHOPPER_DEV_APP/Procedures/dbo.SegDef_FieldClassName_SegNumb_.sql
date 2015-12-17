USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SegDef_FieldClassName_SegNumb_]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SegDef_FieldClassName_SegNumb_    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[SegDef_FieldClassName_SegNumb_] @parm1 varchar ( 15), @parm2 varchar ( 2), @parm3 varchar ( 24) as
       Select * from SegDef
           where FieldClassName =    @parm1
             and SegNumber      =    @parm2
             and ID             like @parm3
           order by FieldClassName, SegNumber, ID
GO
