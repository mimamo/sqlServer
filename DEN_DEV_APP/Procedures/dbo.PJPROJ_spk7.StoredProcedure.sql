USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk7]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk7]  @parm1 varchar (16)  as
select * From PJPROJ
where
status_pa = 'A' and
status_LB = 'A' and
project like @parm1
order by project
GO
