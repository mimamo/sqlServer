USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_04020]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_04020    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[POReceipt_04020] @parm1 varchar ( 10) As
        Select * from POReceipt where
                RcptNbr like @parm1 and
                Batnbr = ''
        Order by RcptNbr
GO
