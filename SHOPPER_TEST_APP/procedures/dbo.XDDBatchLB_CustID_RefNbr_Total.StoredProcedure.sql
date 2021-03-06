USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchLB_CustID_RefNbr_Total]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchLB_CustID_RefNbr_Total]
   	@LBBatNbr	varchar( 10 ),
	@CustID		varchar( 15 ),
   	@RefNbr		varchar( 10 ),
   	@DecPl		smallint

AS

	SELECT 	Coalesce( Sum( Round(Amount, @DecPl) ), 0)
	FROM 	XDDBatchARLB L 
	WHERE	L.LBBatNbr = @LBBatNbr
		and L.CustID = @CustID
		and L.RefNbr = @RefNbr
   		and L.PmtApplicBatNbr = '' 
   		and L.PmtApplicRefNbr = ''

--	SELECT 	Coalesce( Sum( Round(Amount, @DecPl) ), 0)
--	FROM 	XDDBatchARLB L (nolock) LEFT OUTER JOIN Batch B (nolock)
--		ON L.PmtApplicBatNbr = B.BatNbr and 'AR' = B.Module
--	WHERE	L.LBBatNbr = @LBBatNbr
--		and L.CustID = @CustID
--		and L.RefNbr = @RefNbr
-- 		and L.PmtApplicBatNbr = '' 
--		and L.PmtApplicRefNbr = ''
   		-- ) or 
   		--     (L.PmtApplicBatNbr <> '' and L.PmtApplicRefNbr <> '') and B.Status = 'V')
GO
