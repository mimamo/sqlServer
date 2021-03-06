USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDWrkCheckSel_ReGroup]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDWrkCheckSel_ReGroup]
   @AccessNbr		smallint,
   @OrigGroup		varchar( 1 ),
   @NewGroup		varchar( 1 )
   	
AS

   -- Currently supported for only moving into "R"emove group
   UPDATE	XDDWrkCheckSel
   SET		EBGroup = @NewGroup
   WHERE	AccessNbr = @AccessNbr
   		and EBGroup = @OrigGroup 
    
   -- Later, when combining groups, need to consider the Description field    
   -- Change Groups and then combine info on Descriptions:
   -- 0  Format: US-ACH, PPD
   -- 0  Format: US-ACH, CCD
   
   -- 0  Format: US-ACH, PPD, CCD
    
--   DECLARE         Wrk_Cursor CURSOR LOCAL FAST_FORWARD
-- FOR
-- SELECT 		RefNbr,
--	DocType,
--	CuryDocBal,
--	CuryDiscBal,
--	DiscDate,
--	case DocType
--	when 'IN' then '1'
--	when 'DM' then '2'
--	when 'FI' then '3'
--	end As DocSeq
--ROM            ARDoc (nolock)
--HERE		CustID = @CustID
--	and DocType IN ('IN', 'DM', 'FI')
--	and OpenDoc = 1
--	and CuryDocBal > 0
--RDER BY	DocSeq, RefNbr
GO
