USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_PJPENT_sall]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_PJPENT_sall] @parm1 varchar (16) , @PARM2 varchar (32)   as
select * from PJPENT
where project =  @parm1 and
pjt_entity Like  @parm2 and
status_pa = 'A' and
status_ar = 'A'
GO
