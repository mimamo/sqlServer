USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_PV_Cust_DocType_Ref]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_PV_Cust_DocType_Ref    Script Date: 11/5/00 12:30:32 PM ******/
CREATE PROC [dbo].[ARRev_PV_Cust_DocType_Ref] @parm1 varchar (10), @parm2 varchar ( 15), @parm3 varchar ( 10) as
SELECT *
  FROM ARDoc
 WHERE CpnyId = @parm1 AND custid = @parm2 AND
       doctype IN ('FI', 'IN', 'DM', 'NC') AND
       rlsed = 1 AND refnbr like @parm3
 ORDER BY Refnbr, Doctype
GO
