USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cnt_Apply]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cnt_Apply    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[ARDoc_Cnt_Apply] @parm1 varchar ( 15) As
 Select Count(RefNbr) from ARDoc WHERE ARDoc.CustId = @parm1
    and Rlsed = 1
    and doctype IN ('FI', 'IN', 'DM')
    and curydocbal > 0
GO
