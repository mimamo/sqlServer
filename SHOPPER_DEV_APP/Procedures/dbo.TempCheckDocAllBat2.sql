USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TempCheckDocAllBat2]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TempCheckDocAllBat2    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[TempCheckDocAllBat2] @parm1 varchar ( 10)  As
Select * From APCheck Where
BatNbr = @parm1
Order By APCheck.VendId, APCheck.CheckRefNbr
GO
