USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_PostEstimate]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_PostEstimate] @Project varchar(16), @RevID varchar(4)
AS


INSERT INTO [dbo].[PJREVCAT]
           ([Acct]
           ,[Amount]
           ,[crtd_datetime]
           ,[crtd_prog]
           ,[crtd_user]
           ,[lupd_datetime]
           ,[lupd_prog]
           ,[lupd_user]
           ,[NoteId]
           ,[pjt_entity]
           ,[project]
           ,[Rate]
           ,[rc_id01]
           ,[rc_id02]
           ,[rc_id03]
           ,[rc_id04]
           ,[rc_id05]
           ,[rc_id06]
           ,[rc_id07]
           ,[rc_id08]
           ,[rc_id09]
           ,[rc_id10]
           ,[RevId]
           ,[Units]
           ,[user1]
           ,[user2]
           ,[user3]
           ,[user4]
           ,[User5]
           ,[User6]
           ,[User7]
           ,[User8])
     SELECT
           'ESTIMATE TAX'
           ,A.CurrentTax
           ,GETDATE()
           ,'IDALBU'
           ,'IMPORT'
           ,GETDATE()
           ,'IDALBU'
           ,'IMPORT'
           ,0
           ,A.pjt_entity
           ,A.project
           ,0
           ,''
           ,''
           ,''
           ,''
           ,''
           ,0
           ,0
           ,' '
           ,' '
           ,0
           ,A.RevID
           ,0
           ,''
           ,''
           ,0
           ,0
           ,''
           ,''
           ,' '
           ,' '
FROM
	(SELECT DISTINCT
					RT.NoteID,
					RT.pjt_entity_desc,
					RCE.Amount as CurrentAmount,
					RCE.Amount as PreviousAmount,
					RH.RevID,
					RH.Project,
					RCE.Acct,
					RT.pjt_entity,
					C.Name,
					TaxRate.TaxRate,
					ISNULL(RateTable.Rate_level, 0) as Rate_Level,
					(ISNULL(PR.Rate, 1) + 1) as Commission,
					CASE
						WHEN RH.Status = 'P' THEN RCE.Amount
						ELSE (RCE.Amount * (ISNULL(PR.Rate, 0) + 1))
					END as FinalCurrentAmount,
					ISNULL(RCPE.Amount, 0) as FinalPreviousAmount,
					CASE
						WHEN RH.Status = 'P' THEN ISNULL(RCT.Amount, 0)
						ELSE (CASE
								WHEN PC.data4 = 1 THEN ((RCE.Amount) * TaxRate.TaxRate) - (RCE.Amount)
								ELSE 0
							 END)
					END as CurrentTax,
					ISNULL(RCPT.Amount, 0) as PreviousTax,
					RateTable.effect_date
			FROM
				(SELECT
						PH.Project,
						PH.RevID,
						ISNULL(A.PrevRevID, ISNULL(B.PrevRevID, '')) as PrevRevID,
						PH.Status
				FROM
						(SELECT * FROM PJREVHDR WHERE Project = @project and RevID = @RevID) PH
						LEFT OUTER JOIN	(SELECT
											PJREVHDR.Project,
											PJREVHDR.RevID,
											PJPROJEX.pm_id25 as PrevRevID
										FROM
											PJREVHDR
											INNER JOIN PJPROJEX
												ON PJPROJEX.project = PJREVHDR.Project
										WHERE
											pm_id25 < RevID AND
											pm_id25 <> '' ) A
							ON PH.Project = A.Project AND
							   PH.RevID = A.RevID
						LEFT OUTER JOIN (SELECT
											RH.Project,
											RH.RevID,
											MAX(RH1.RevID) as PrevRevID
										FROM
											(SELECT * FROM PJREVHDR WHERE Project = @project and RevID = @RevID) RH
											INNER JOIN (SELECT * FROM PJREVHDR WHERE status = 'P') RH1
												ON RH.Project = RH1.Project AND
												   RH.RevID > RH1.RevID
										GROUP BY
											RH.Project,
											RH.RevID) B
							ON PH.Project = B.Project AND
							   PH.RevID = B.RevID) RH
					INNER JOIN PJREVTSK RT
						ON RH.Project = RT.Project AND
						   RH.RevID = RT.RevID
					INNER JOIN PJPROJ PP
						ON PP.Project = RH.Project
					INNER JOIN Customer C
						ON PP.Customer = C.CustID
					LEFT OUTER JOIN PJCODE PC
						ON RT.pjt_entity = PC.code_value AND
						   PC.code_type = '0FUN'
					LEFT OUTER JOIN PJADDR PA
						ON PP.Project = PA.addr_key AND
						   PA.addr_type_cd = 'BI'
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE') RCE
						ON RH.Project = RCE.Project AND
						   RH.RevID = RCE.RevID AND
						   RT.pjt_entity = RCE.pjt_entity
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE TAX') RCT
						ON RH.Project = RCT.Project AND
						   RH.RevID = RCT.RevID AND
						   RT.pjt_entity = RCT.pjt_entity
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE') RCPE
						ON RH.Project = RCPE.Project AND
						   RH.PrevRevID = RCPE.RevID AND
						   RT.pjt_entity = RCPE.pjt_entity
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE TAX') RCPT
						ON RH.Project = RCPT.Project AND
						   RH.PrevRevID = RCPT.RevID AND
						   RT.pjt_entity = RCPT.pjt_entity
					LEFT OUTER JOIN (SELECT
									SUM(ISNULL(TaxRate, 0)) / 100 + 1 as TaxRate,
									Customer.CustID
								FROM
									Customer
									LEFT OUTER JOIN SalesTax
										ON customer.TaxID00 = SalesTax.TaxID OR
										   customer.TaxID01 = SalesTax.TaxID OR
										   customer.TaxID02 = SalesTax.TaxID OR
										   customer.TaxID03 = SalesTax.TaxID OR
										   customer.TaxLocID = SalesTax.TaxID
								GROUP BY
									customer.CustID) TaxRate 
						ON C.CustID = TaxRate.CustID
					LEFT OUTER JOIN (SELECT
										PP.Project,
										C.CustID,
										RT.pjt_entity,
										MIN(RateTable.Rate_Level) as Rate_level,
										MAX(RateTable.Effect_Date) as effect_date,
										RateTable.Rate_Table_ID
									FROM
										PJREVTSK RT												
										LEFT OUTER JOIN PJPROJ PP
											ON PP.Project = RT.Project	
										LEFT OUTER JOIN Customer C
											ON PP.Customer = C.CustID
										INNER JOIN (SELECT
														Rate_key_value1,
														Rate_key_value2,
														Rate_Level,
														Rate_Table_ID,
														Effect_date
													FROM
														PJRATE
													WHERE
														rate_type_cd = 'HC') RateTable
											ON RateTable.Rate_Table_ID = PP.Rate_table_id AND
											   ((PP.Project = RateTable.Rate_key_value1 AND
												RT.pjt_entity = RateTable.Rate_key_value2) OR
											   (C.CustID = RateTable.Rate_key_value1 AND
												RT.pjt_entity = RateTable.Rate_key_value2) OR
											   (PP.Project = RateTable.Rate_key_value1 AND
												RateTable.Rate_key_value2 = '') OR
											   (C.CustID = RateTable.Rate_key_value1 AND
												RateTable.Rate_key_value2 = '') OR
											   (RT.pjt_entity = RateTable.Rate_key_value1 AND
												RateTable.Rate_key_value2 = '') OR
												(C.CustID = RateTable.Rate_key_value1 AND
												SUBSTRING(PP.Project, 4, 3) = RateTable.Rate_key_value2)) AND
											   PP.start_date >= RateTable.Effect_date
										GROUP BY
											PP.Project,
											C.CustID,
											RT.pjt_entity,
											RateTable.Rate_Table_ID) RateTable	
							ON RateTable.Project = PP.Project AND
							   RateTable.pjt_entity = RT.pjt_entity
					LEFT OUTER JOIN PJRATE PR
						ON PR.Rate_Table_ID = PP.Rate_table_id AND
						  ((PP.Project = PR.Rate_key_value1 AND
						   RT.pjt_entity = PR.Rate_key_value2) OR
						   (C.CustID = PR.Rate_key_value1 AND
							RT.pjt_entity = PR.Rate_key_value2) OR
						   (PP.Project = PR.Rate_key_value1 AND
							RTRIM(PR.Rate_key_value2) = '') OR
						   (C.CustID = PR.Rate_key_value1 AND
							PR.Rate_key_value2 = '') OR
						   (RT.pjt_entity = PR.Rate_key_value1 AND
							PR.Rate_key_value2 = '') OR
						   (C.CustID = PR.Rate_key_value1 AND
							SUBSTRING(PP.Project, 4, 3) = PR.Rate_key_value2)) AND
						   RateTable.Rate_Level = PR.Rate_Level AND
						   PR.Rate_type_cd = 'HC' AND
						   PR.effect_date = RateTable.Effect_Date) A
WHERE
	A.CurrentTax <> 0


UPDATE 
	PJREVCAT
SET
	PJREVCAT.Amount = A.FinalCurrentAmount, PJREVCAT.User3 = A.Commission
FROM
	PJREVCAT
	INNER JOIN (SELECT DISTINCT
					RT.NoteID,
					RT.pjt_entity_desc,
					RCE.Amount as CurrentAmount,
					RCE.Amount as PreviousAmount,
					RH.RevID,
					RH.Project,
					RCE.Acct,
					RT.pjt_entity,
					C.Name,
					TaxRate.TaxRate,
					ISNULL(RateTable.Rate_level, 0) as Rate_Level,
					(ISNULL(PR.Rate, 0) + 1) as Commission,
					CASE
						WHEN RH.Status = 'P' THEN RCE.Amount
						ELSE (RCE.Amount * (ISNULL(PR.Rate, 0) + 1))
					END as FinalCurrentAmount,
					ISNULL(RCPE.Amount, 0) as FinalPreviousAmount,
					CASE
						WHEN RH.Status = 'P' THEN ISNULL(RCT.Amount, 0)
						ELSE (CASE
								WHEN PC.data4 = 1 THEN ((RCE.Amount) * TaxRate.TaxRate) - (RCE.Amount)
								ELSE 0
							 END)
					END as CurrentTax,
					ISNULL(RCPT.Amount, 0) as PreviousTax,
					RateTable.effect_date
			FROM
				(SELECT
						PH.Project,
						PH.RevID,
						ISNULL(A.PrevRevID, ISNULL(B.PrevRevID, '')) as PrevRevID,
						PH.Status
				FROM
						(SELECT * FROM PJREVHDR WHERE Project = @project and RevID = @RevID) PH
						LEFT OUTER JOIN	(SELECT
											PJREVHDR.Project,
											PJREVHDR.RevID,
											PJPROJEX.pm_id25 as PrevRevID
										FROM
											PJREVHDR
											INNER JOIN PJPROJEX
												ON PJPROJEX.project = PJREVHDR.Project
										WHERE
											pm_id25 < RevID AND
											pm_id25 <> '' ) A
							ON PH.Project = A.Project AND
							   PH.RevID = A.RevID
						LEFT OUTER JOIN (SELECT
											RH.Project,
											RH.RevID,
											MAX(RH1.RevID) as PrevRevID
										FROM
											(SELECT * FROM PJREVHDR WHERE Project = @project and RevID = @RevID) RH
											INNER JOIN (SELECT * FROM PJREVHDR WHERE status = 'P') RH1
												ON RH.Project = RH1.Project AND
												   RH.RevID > RH1.RevID
										GROUP BY
											RH.Project,
											RH.RevID) B
							ON PH.Project = B.Project AND
							   PH.RevID = B.RevID) RH
					INNER JOIN PJREVTSK RT
						ON RH.Project = RT.Project AND
						   RH.RevID = RT.RevID
					INNER JOIN PJPROJ PP
						ON PP.Project = RH.Project
					INNER JOIN Customer C
						ON PP.Customer = C.CustID
					LEFT OUTER JOIN PJCODE PC
						ON RT.pjt_entity = PC.code_value AND
						   PC.code_type = '0FUN'
					LEFT OUTER JOIN PJADDR PA
						ON PP.Project = PA.addr_key AND
						   PA.addr_type_cd = 'BI'
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE') RCE
						ON RH.Project = RCE.Project AND
						   RH.RevID = RCE.RevID AND
						   RT.pjt_entity = RCE.pjt_entity
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE TAX') RCT
						ON RH.Project = RCT.Project AND
						   RH.RevID = RCT.RevID AND
						   RT.pjt_entity = RCT.pjt_entity
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE') RCPE
						ON RH.Project = RCPE.Project AND
						   RH.PrevRevID = RCPE.RevID AND
						   RT.pjt_entity = RCPE.pjt_entity
					LEFT OUTER JOIN (SELECT * FROM PJREVCAT WHERE acct = 'ESTIMATE TAX') RCPT
						ON RH.Project = RCPT.Project AND
						   RH.PrevRevID = RCPT.RevID AND
						   RT.pjt_entity = RCPT.pjt_entity
					LEFT OUTER JOIN (SELECT
									SUM(ISNULL(TaxRate, 0)) / 100 + 1 as TaxRate,
									Customer.CustID
								FROM
									Customer
									LEFT OUTER JOIN SalesTax
										ON customer.TaxID00 = SalesTax.TaxID OR
										   customer.TaxID01 = SalesTax.TaxID OR
										   customer.TaxID02 = SalesTax.TaxID OR
										   customer.TaxID03 = SalesTax.TaxID OR
										   customer.TaxLocID = SalesTax.TaxID
								GROUP BY
									customer.CustID) TaxRate 
						ON C.CustID = TaxRate.CustID
					LEFT OUTER JOIN (SELECT
										PP.Project,
										C.CustID,
										RT.pjt_entity,
										MIN(RateTable.Rate_Level) as Rate_level,
										MAX(RateTable.Effect_Date) as effect_date,
										RateTable.Rate_Table_ID
									FROM
										PJREVTSK RT												
										LEFT OUTER JOIN PJPROJ PP
											ON PP.Project = RT.Project	
										LEFT OUTER JOIN Customer C
											ON PP.Customer = C.CustID
										INNER JOIN (SELECT
														Rate_key_value1,
														Rate_key_value2,
														Rate_Level,
														Rate_Table_ID,
														Effect_date
													FROM
														PJRATE
													WHERE
														rate_type_cd = 'HC') RateTable
											ON RateTable.Rate_Table_ID = PP.Rate_table_id AND
											   ((PP.Project = RateTable.Rate_key_value1 AND
												RT.pjt_entity = RateTable.Rate_key_value2) OR
											   (C.CustID = RateTable.Rate_key_value1 AND
												RT.pjt_entity = RateTable.Rate_key_value2) OR
											   (PP.Project = RateTable.Rate_key_value1 AND
												RateTable.Rate_key_value2 = '') OR
											   (C.CustID = RateTable.Rate_key_value1 AND
												RateTable.Rate_key_value2 = '') OR
											   (RT.pjt_entity = RateTable.Rate_key_value1 AND
												RateTable.Rate_key_value2 = '') OR
												(C.CustID = RateTable.Rate_key_value1 AND
												SUBSTRING(PP.Project, 4, 3) = RateTable.Rate_key_value2)) AND
											   PP.start_date >= RateTable.Effect_date
										GROUP BY
											PP.Project,
											C.CustID,
											RT.pjt_entity,
											RateTable.Rate_Table_ID) RateTable	
							ON RateTable.Project = PP.Project AND
							   RateTable.pjt_entity = RT.pjt_entity
					LEFT OUTER JOIN PJRATE PR
						ON PR.Rate_Table_ID = PP.Rate_table_id AND
						  ((PP.Project = PR.Rate_key_value1 AND
						   RT.pjt_entity = PR.Rate_key_value2) OR
						   (C.CustID = PR.Rate_key_value1 AND
							RT.pjt_entity = PR.Rate_key_value2) OR
						   (PP.Project = PR.Rate_key_value1 AND
							RTRIM(PR.Rate_key_value2) = '') OR
						   (C.CustID = PR.Rate_key_value1 AND
							PR.Rate_key_value2 = '') OR
						   (RT.pjt_entity = PR.Rate_key_value1 AND
							PR.Rate_key_value2 = '') OR
						   (C.CustID = PR.Rate_key_value1 AND
							SUBSTRING(PP.Project, 4, 3) = PR.Rate_key_value2)) AND
						   RateTable.Rate_Level = PR.Rate_Level AND
						   PR.Rate_type_cd = 'HC' AND
						   PR.effect_date = RateTable.Effect_Date) A
			ON A.Project = PJREVCAT.Project AND
			   A.pjt_entity = PJREVCAT.pjt_entity AND
			   A.RevID = PJREVCAT.RevID AND
			   A.Acct = PJREVCAT.Acct AND
			   PJREVCAT.Acct = 'ESTIMATE'

EXEC xAlt_PostBudget @Project, @RevID
GO
