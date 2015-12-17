USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_PV_Custid_Refnbr2]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_PV_Custid_Refnbr2    Script Date: 11/21/00 12:30:33 PM ******/
CREATE PROC [dbo].[ARRev_PV_Custid_Refnbr2] @parm1 varchar(10), @parm2 varchar(15), @parm3 varchar(10) AS
SELECT *
  FROM ARDoc
 WHERE CpnyId = @parm1
   AND CustID like @parm2
   AND refnbr like @parm3
   AND doctype IN ('PA', 'CM', 'PP', 'SB')
   AND Rlsed = 1
Order by Refnbr
GO
