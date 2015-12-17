USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Load_PR_PP]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Load_PR_PP]
   @BatNbr	varchar(10)

AS
   SELECT	*
   FROM		PRDoc (NoLock)
   WHERE	(	(PRDoc.Status <> 'V' and PRDoc.DocType <> 'VC') or	-- No voids in orig batch
   			(PRDoc.Status = 'V' and PRDoc.DocType = 'VC') 		-- Only voids in void batch
   		)
   		and PRDoc.Batnbr = @BatNbr
   		and PRDoc.DocType <> 'ZC'				-- No Zero Checks
   		and PRDoc.DocType <> 'SC'				-- No Stub Checks
GO
