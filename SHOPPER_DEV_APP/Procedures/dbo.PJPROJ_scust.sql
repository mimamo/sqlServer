USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_scust]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_scust] @parm1 varchar (15), @parm2 varchar (16)  as
select * from PJPROJ
where customer = @parm1
and project like @parm2
order by project
GO
