USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSDET_sunrel]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSDET_sunrel]  @parm1 varchar (16) ,  @parm2 varchar (6)  as
select * from PJBSDET
where    PJBSDET.Project = @parm1
and PJBSDET.Schednbr= @parm2
and PJBSDET.Rel_Status <> 'Y'
order by project, schednbr
GO
