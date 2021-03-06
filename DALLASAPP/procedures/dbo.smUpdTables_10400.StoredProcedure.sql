USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smUpdTables_10400]    Script Date: 12/21/2015 13:45:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smUpdTables_10400]
	@BatchNbr CHAR(10),
	@RefNbr CHAR(15),
	@InvtID CHAR(20),
	@Crtd_Prog CHAR(8),
	@ExtCost MONEY,
	@UnitCost MONEY,
	@LineID INT
AS
		/* Update the smServDetail table */
		UPDATE smServDetail
			SET 	smServDetail.TranAmt = @ExtCost,
				smServDetail.Cost = @UnitCost,
			    	smServDetail.Profit = (smServDetail.ExtPrice - @ExtCost),
			    	smServDetail.ProfitPercent = (SELECT (CASE
			    						WHEN (smServDetail.ExtPrice = 0) AND (@ExtCost < 0) THEN -9999.99
			    						WHEN smServDetail.ExtPrice = 0 THEN 0
			    						ELSE (smServDetail.ExtPrice - @ExtCost)/smServDetail.ExtPrice * 100
								      END))

			WHERE 	smServDetail.INBatNbr = @BatchNbr
				AND smServDetail.ServiceCallID = @RefNbr
				AND smServDetail.InvtID = @InvtID
				AND smServDetail.TM_ID20 = @LineID
				AND (RTRIM(@Crtd_Prog) = 'SD306' OR RTRIM(@Crtd_Prog) = 'SD642')

		/* Update the smInvDetail table only if the IN Batch was created from SD642 */
		IF RTRIM(@Crtd_Prog) = 'SD642'
			BEGIN
				UPDATE smInvDetail
					SET smInvDetail.TranAmt = smServDetail.TranAmt, smInvDetail.Cost = smServDetail.Cost
					FROM smServDetail
					WHERE smServDetail.INBatNbr = @BatchNbr
					AND smServDetail.ServiceCallID = @RefNbr
					AND smServDetail.InvtID = @InvtID
					AND smServDetail.TM_ID20 = @LineID
					AND smServDetail.ServiceCallID = smInvDetail.DocumentID
					AND smServDetail.LineNbr = smInvDetail.LineNbr
			END
GO
