USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_RefNum]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_RefNum    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[Delete_RefNum] @parm1 varchar ( 10) As
Delete refnbr from RefNbr where
        RefNbr.Refnbr = @parm1
GO
