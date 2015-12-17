USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_spk4]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_spk4]  @parm1 varchar (16) , @parm2 varchar (10)  as
select * from PJPROJ
where
project like @parm1 and
cpnyid = @parm2 and
(status_pa = 'A' or  status_pa = 'I')  and
alloc_method_cd <> ' '
order by project
GO
