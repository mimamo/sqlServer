USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Rlsed_CustId]    Script Date: 12/21/2015 16:00:49 ******/
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
