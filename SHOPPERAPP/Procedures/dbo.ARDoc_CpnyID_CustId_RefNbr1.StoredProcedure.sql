USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyID_CustId_RefNbr1]    Script Date: 12/21/2015 16:13:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CpnyID_CustId_RefNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_CpnyID_CustId_RefNbr1] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 10) as
    SELECT *
      FROM ardoc
     WHERE CpnyId LIKE @parm1
       AND custid = @parm2
       AND refnbr like @parm3
       AND doctype IN ('FI', 'IN', 'DM', 'NC')
       AND curydocbal > 0
       AND Rlsed = 1
     ORDER BY CustId, Refnbr
GO
