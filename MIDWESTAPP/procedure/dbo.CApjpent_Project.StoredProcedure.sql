USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[CApjpent_Project]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[CApjpent_Project] @Parm1 Varchar(16), @Parm2 Varchar(32) as
select * from PJPENT where project = @parm1
and pjt_entity like @parm2 and status_pa = 'A'
order by project, pjt_entity
GO
