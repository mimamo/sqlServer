USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Piabc_All]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Piabc_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Piabc_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[Piabc_All] @parm1 varchar ( 02) as
            Select * from piabc where abccode like @parm1
                order by abccode
GO
