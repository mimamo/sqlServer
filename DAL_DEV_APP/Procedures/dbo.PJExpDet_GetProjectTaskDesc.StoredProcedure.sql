USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJExpDet_GetProjectTaskDesc]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJExpDet_GetProjectTaskDesc]  
		    @Guid As UNIQUEIDENTIFIER,
		    @DocNbr as char(10)
as
BEGIN
	SET NOCOUNT ON

	DECLARE @PJExpDet_cursor cursor
	DECLARE @seq int
	DECLARE @LineNbr smallint
	DECLARE @ProjectDesc varchar(30)
	DECLARE @TaskDesc varchar(30)
	
	SET @seq = 0
	SET @LineNbr = 0
	SET @ProjectDesc = ''
	SET @TaskDesc = ''

	SET @PJExpDet_cursor = CURSOR FOR
	select ed.linenbr,
	"project_desc" = 
	      CASE
		WHEN p.project_desc IS NULL THEN 'None'
		ELSE p.project_desc
	      END,
	"pjt_entity_desc" = 
	      CASE
		WHEN pp.pjt_entity_desc IS NULL THEN 'None'
		ELSE pp.pjt_entity_desc
	      END
	from PJExpDet as ed
	left outer join PJProj as p on ed.project = p.project
	left outer join PJPent as pp on ed.project = pp.project and ed.pjt_entity = pp.pjt_entity
	where ed.docnbr = @DocNbr

	OPEN @PJExpDet_cursor



	FETCH NEXT FROM @PJExpDet_cursor INTO @LineNbr, @ProjectDesc, @TaskDesc
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO StoredProcedureResultSet (ID, SequenceNumber, Body)
			VALUES (@Guid, @seq, '<Description><LineNbr>'+cast(@LineNbr as varchar)+'</LineNbr><ProjectDesc>'+dbo.XMLEncode(RTRIM(@ProjectDesc))+'</ProjectDesc><TaskDesc>'+dbo.XMLEncode(RTRIM(@TaskDesc))+'</TaskDesc></Description>')			

			SET @seq = @seq + 1
			FETCH NEXT FROM @PJExpDet_cursor INTO @LineNbr, @ProjectDesc, @TaskDesc
		END	


	CLOSE @PJExpDet_cursor
	DEALLOCATE @PJExpDet_cursor
	
END
GO
