USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[delete_ARTran]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.delete_ARTran    Script Date: 4/7/98 12:30:34 PM ******/
Create PROC [dbo].[delete_ARTran] @parm1 varchar ( 6) As
        DELETE artran FROM ARTran WHERE PerPost <= @parm1
        AND NOT EXISTS (SELECT ARDoc.RefNbr FROM ARDoc WHERE ARDoc.RefNbr = ARTran.RefNbr)
GO
