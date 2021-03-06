USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJInvDet_GetProjectTaskDesc]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJInvDet_GetProjectTaskDesc]  
		    @Guid As UNIQUEIDENTIFIER,
		    @DraftNum as char(10)
as
BEGIN
	SET NOCOUNT ON

	DECLARE @PJInvDet_cursor cursor
	DECLARE @seq int
	DECLARE @SourceTrxId int
	DECLARE @ProjectDesc varchar(30)
	DECLARE @TaskDesc varchar(30)
	DECLARE @EmpName varchar(40)
	
	SET @seq = 0
	SET @SourceTrxId = 0
	SET @ProjectDesc = ''
	SET @TaskDesc = ''
	SET @EmpName = ''

	SET @PJInvDet_cursor = CURSOR FOR
	select vd.source_trx_id,
	"project_desc" = 
	      CASE
		WHEN p.project_desc IS NULL THEN 'None'
		ELSE p.project_desc
	      END,
	"pjt_entity_desc" = 
	      CASE
		WHEN pp.pjt_entity_desc IS NULL THEN 'None'
		ELSE pp.pjt_entity_desc
	      END,
	"emp_name" = 
	      CASE
		WHEN e.emp_name IS NULL THEN 'None'
		ELSE e.emp_name
	      END
	from PJInvDet as vd
	left outer join PJProj as p on vd.project = p.project
	left outer join PJPent as pp on vd.project = pp.project and vd.pjt_entity = pp.pjt_entity
	left outer join PJEmploy as e on vd.employee = e.employee
	where vd.draft_num = @DraftNum

	OPEN @PJInvDet_cursor


	FETCH NEXT FROM @PJInvDet_cursor INTO @SourceTrxId, @ProjectDesc, @TaskDesc, @EmpName
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO StoredProcedureResultSet (ID, SequenceNumber, Body)
			VALUES (@Guid, @seq, '<Description><SourceTrxId>'+cast(@SourceTrxId as varchar)+'</SourceTrxId><ProjectDesc>'+dbo.XMLEncode(RTRIM(@ProjectDesc))+'</ProjectDesc><TaskDesc>'+dbo.XMLEncode(RTRIM(@TaskDesc))+'</TaskDesc><EmpName>'+dbo.XMLEncode(RTRIM(@EmpName))+'</EmpName></Description>')			

			SET @seq = @seq + 1
			FETCH NEXT FROM @PJInvDet_cursor INTO @SourceTrxId, @ProjectDesc, @TaskDesc, @EmpName
		END	


	CLOSE @PJInvDet_cursor
	DEALLOCATE @PJInvDet_cursor
	
END
GO
