USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[KeepAPCheckDocBat]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.KeepAPCheckDocBat    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[KeepAPCheckDocBat] @parm1 varchar ( 10) As
        Select * From APCheck Where
                BatNbr = @parm1 and
                Status = 'T'
         Order By BatNbr, CheckRefNbr
GO
