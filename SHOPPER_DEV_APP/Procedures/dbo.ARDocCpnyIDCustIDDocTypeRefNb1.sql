USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDocCpnyIDCustIDDocTypeRefNb1]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARDocCpnyIDCustIDDocTypeRefNb1]  @parm1 AS varchar (15),  @parm2 AS varchar (15),  @parm3 AS varchar (15),  @parm4 AS varchar (15) AS
SELECT *
  FROM ARDoc
 WHERE CpnyID LIKE @parm1
   AND CustID LIKE @parm2
   AND DocType LIKE @parm3
   AND RefNbr LIKE @parm4
   AND DocType <> 'RC'
 ORDER BY CpnyID, RefNbr
GO
