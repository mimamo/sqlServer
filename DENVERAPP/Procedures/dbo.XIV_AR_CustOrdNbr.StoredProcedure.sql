USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_AR_CustOrdNbr]    Script Date: 12/21/2015 15:43:15 ******/
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
