USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Rlsed_CustId]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Rlsed_CustId    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_Rlsed_CustId] @parm1 varchar ( 15) as
        SELECT * FROM ARDoc WHERE Rlsed = 1
        AND DocType <> 'VT'
        AND CustId = @parm1
        ORDER BY CustId, RefNbr
GO
