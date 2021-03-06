USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDocCpnyIDCustIDDocTypeRefNbr]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARDocCpnyIDCustIDDocTypeRefNbr]  @parm1 AS varchar (15),  @parm2 AS varchar (15),  @parm3 AS varchar (15),  @parm4 AS varchar (15) AS
SELECT *
  FROM ARDoc
 WHERE CpnyID LIKE @parm1
   AND CustID LIKE @parm2
   AND DocType LIKE @parm3
   AND RefNbr LIKE @parm4
   AND DocType <> 'RC'
 ORDER BY CustID, DocType, RefNbr
GO
