USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CheckAdjs]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08990CheckAdjs] AS
INSERT INTO WrkIChk (Custid, Cpnyid, MsgID, OldBal, NewBal, AdjBal, Other)
SELECT v.custid, v.doctype, 50, v.origdocamt, v.docbal, v.SumOfAllAdjs, v.refnbr
  FROM vi_08990CompareAdjs v
 WHERE v.DocBalPlusAdjs <> v.origdocamt or v.curyDocBalPlusAdjs <> v.curyorigdocamt
GO
