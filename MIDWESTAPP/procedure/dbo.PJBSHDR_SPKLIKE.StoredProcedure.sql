USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSHDR_SPKLIKE]    Script Date: 12/21/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSHDR_SPKLIKE]  @parm1 varchar (16) , @parm2 varchar (6)   as
select * from PJBSHDR
where    project     LIKE @parm1 and
schednbr LIKE @parm2
order by project, schednbr
GO
