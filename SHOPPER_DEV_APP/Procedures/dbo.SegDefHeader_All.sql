USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SegDefHeader_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SegDefHeader_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[SegDefHeader_All] @parm1 varchar ( 15), @parm2 varchar ( 2) as
       Select * from SegDefHeader
           where FieldClassName like @parm1
             and SegNumber      like @parm2
           order by FieldClassName,
                    SegNumber
GO
