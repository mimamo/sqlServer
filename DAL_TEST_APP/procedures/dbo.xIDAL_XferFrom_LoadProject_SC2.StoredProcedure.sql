USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_XferFrom_LoadProject_SC2]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_XferFrom_LoadProject_SC2] 
			@project char(16),
			@prog char(8),
			@user char(10)
AS

set nocount on

declare @JobType	varchar(2),
		@ActualAmount float

	SET @JobType = RIGHT(RTRIM(@Project), 2)



	begin transaction

	delete from xIDAL_XferFrom
		where project = @project

	delete from xIDAL_XferFrom
		where project = @project

	IF NOT EXISTS (SELECT * FROM PJTRAN INNER JOIN PJACCT ON PJTRAN.ACCT = PJACCT.Acct WHERE PJACCT.ca_id05 = 'SL' AND PJTRAN.Data1 <> 'PREBILL' AND PJTRAN.Project = @Project) 
		BEGIN
			insert xIDAL_XferFrom(
				act_amount,
				crtd_datetime,
				crtd_prog,
				crtd_user,
				est_amount, 
				pjt_entity,
				entityDesc,
				project)
			select 
				sum(s.act_amount),
				getdate(),
				@prog,
				@user,
				sum(s.act_amount),
				s.pjt_entity,
				t.pjt_entity_desc,
				s.project
			from
				PJPTDSum as s 
					join PJAcct as a on s.acct = a.acct
					join PJPent as t on s.project = t.project and s.pjt_entity = t.pjt_entity
			where
				s.project = @project and
				(s.act_amount != 0 or
					s.eac_amount != 0) and
				a.ca_id05 = 'PB'
			group by 
				s.project,
				s.pjt_entity,
				t.pjt_entity_desc
		--order by 6,4

			-- udpate btd amount
			update x
			set btd_amount = ISNULL(PTD.act_amount, 0)
			FROM
				xIDAL_XFerFrom x
				LEFT OUTER JOIN (SELECT SUM(act_amount) act_amount, project, pjt_entity FROM PJPTDSUM WHERE PJPTDSUM.acct LIKE 'SALES%' AND PJPTDSUM.Project = @Project GROUP BY Project, pjt_entity) PTD
					ON x.project = PTD.Project AND
					   x.pjt_entity = PTD.pjt_entity


			-- udpate cos amount
			update xIDAL_XferFrom
				set cos_amount = (select isnull(sum(PTD.act_amount),0.0)
							from PJPTDSum PTD
							where	PTD.project = xIDAL_XferFrom.project and
								PTD.pjt_entity = xIDAL_XferFrom.pjt_entity and
								PTD.acct LIKE 'COS%')
			where 
				project = @project
			

			
			UPDATE s
			SET s.act_amount = CASE
									WHEN s.act_amount <= ACT.act_amount THEN ACT.act_amount 
									ELSE s.act_amount
								END
			FROM
				  xIDAL_XFerFrom s
				 INNER JOIN (select isnull(sum(PTD.act_amount),0.0) as act_amount, PTD.Project, PTD.pjt_entity
							from PJPTDSum PTD
							INNER JOIN PJACCT PA
								ON PTD.acct = PA.acct
							where	PTD.project = @project AND
									PA.ca_id05 = 'AC'
							GROUP BY PTD.project, PTD.pjt_entity) ACT
					ON act.Project = s.Project AND
					   act.pjt_entity = s.pjt_entity


			update xIDAL_XferFrom
				set var_amount = 0,
					rem_amount = act_amount - btd_amount,
					bill_amount = act_amount - btd_amount
			where 
				project = @project




		END

			commit transaction
GO
