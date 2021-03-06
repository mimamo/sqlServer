USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk42]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk42]  @parm1 varchar (4) , @parm2 varchar (10) as
select * from PJPROJ
where
        alloc_method_cd = @parm1 and
        cpnyid = @parm2 and
        (status_pa = 'A' or  status_pa = 'I')  and
        alloc_method_cd <> ' '
order by
        alloc_method_cd, rate_table_id, project
GO
