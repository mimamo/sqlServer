USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk9]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk9] @parm1 varchar (250) , @parm2 varchar (16)  as
select * from PJPROJ
where project = @parm2
order by project
GO
