USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_04020]    Script Date: 12/21/2015 16:07:15 ******/
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
