USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_AR_CustOrdNbr]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[XIV_AR_CustOrdNbr] 
@parm1 VarChar(15)
As
Select * from ARDoc
Where CustOrdNbr like @parm1
Order by CustOrdNbr, CustId, DocType, RefNbr
GO
