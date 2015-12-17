USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLBApplic_Pmt_Applic]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLBApplic_Pmt_Applic]
   @PmtRecordID		int

AS
   SELECT	*
   FROM		XDDBatchARLBApplic X LEFT OUTER JOIN ARDoc A
		ON X.CustID = A.CustID and X.RefNbr = A.RefNbr and X.DocType = A.DocType
   WHERE	X.PmtRecordID = @PmtRecordID
   		and (X.ApplyAmount + X.DiscApplyAmount) > 0
   ORDER BY	X.LineNbr
GO
