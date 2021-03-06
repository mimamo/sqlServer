USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk41]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk41]  @parm1 varchar (4) , @parm2 varchar (24) , @parm3 varchar (10) as
select * from PJPROJ
where
        alloc_method_cd like @parm1 and
        gl_subacct like @parm2 and
        cpnyid = @parm3 and
        (status_pa = 'A' or  status_pa = 'I')  and
        alloc_method_cd <> ' '
order by
        alloc_method_cd, rate_table_id, project
GO
