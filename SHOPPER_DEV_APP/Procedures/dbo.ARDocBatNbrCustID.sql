USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDocBatNbrCustID]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARDocBatNbrCustID]  @parm1 AS varchar (10) , @parm2 as varchar (15), @parm3 as varchar (15) as
SELECT * FROM ARDoc WHERE
BatNbr LIKE @parm1 AND
CustID LIKE @parm2 AND
RefNbr LIKE @parm3 AND
DocType <> 'RC'
ORDER BY BatNBr, CustID, RefNbr
GO
