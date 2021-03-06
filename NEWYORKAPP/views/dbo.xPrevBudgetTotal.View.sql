USE [NEWYORKAPP]
GO
/****** Object:  View [dbo].[xPrevBudgetTotal]    Script Date: 12/21/2015 16:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xPrevBudgetTotal]
AS
SELECT DISTINCT
	RT.NoteID,
	RT.pjt_entity_desc,
	RC.CurrentAmount,
	RC.PreviousAmount,
	RC.RevID,
	RC.Project,
	RC.Acct,
	RC.pjt_entity
FROM
	PJREVTSK RT
	INNER JOIN 
				(SELECT
					ISNULL(RC.Acct, PR.Acct) as Acct,
					ISNULL(RC.Project, PR.Project) as Project,
					ISNULL(RC.pjt_entity, PR.pjt_entity) as pjt_entity,
					ISNULL(RC.RevID, PR.LinkRevID) as RevID,
					ISNULL(PR.RevID, '0000') as PrevRevID,
					ISNULL(RC.Amount, 0) as CurrentAmount,
					ISNULL(PR.Amt, 0) as PreviousAmount
				FROM
					PJREVCAT RC
					FULL OUTER JOIN
									(SELECT     
										SUM(Amount) AS amt, 
										RevId, 
										RIGHT('0000' + CAST(RevId + 1 AS varchar(10)), 4) AS LinkRevID, 
										project, 
										pjt_entity,
										Acct
									FROM         
										dbo.PJREVCAT
									GROUP BY 
										RevId, 
										project, 
										pjt_entity,
										Acct) PR
						ON RC.pjt_entity = PR.pjt_entity AND
						   RC.RevID = PR.LinkRevID AND
						   RC.Project = PR.Project AND
						   RC.Acct = PR.Acct) RC
		ON RT.Project = RC.Project AND
		   RT.pjt_entity = RC.pjt_entity AND
		   (RT.RevID = RC.RevID OR
			RT.RevID = RC.PrevRevID)
GO
