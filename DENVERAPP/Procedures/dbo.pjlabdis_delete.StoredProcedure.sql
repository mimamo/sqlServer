USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjlabdis_delete]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjlabdis_delete] @parm1 varchar (06) as
delete from pjlabdis
where pjlabdis.fiscalno <= @parm1
GO
