USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[KeepAPCheckDocBat]    Script Date: 12/21/2015 15:36:58 ******/
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
