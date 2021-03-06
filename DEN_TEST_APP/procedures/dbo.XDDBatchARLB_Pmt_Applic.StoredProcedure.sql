USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_Pmt_Applic]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLB_Pmt_Applic]
   @LBBatNbr		varchar(10)

AS
   SELECT	*
   FROM		XDDBatchARLB X LEFT OUTER JOIN Customer C
		ON X.CustID = C.CustID
   WHERE	X.LBBatNbr = @LBBatNbr
   		and X.PmtApplicBatNbr = ''
		and X.PmtApplicRefNbr = ''
   ORDER BY	X.CpnyID, X.CuryID, X.CustID, X.RefNbr, X.LineNbr
GO
