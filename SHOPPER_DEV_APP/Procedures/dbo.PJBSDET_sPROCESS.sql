USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSDET_sPROCESS]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSDET_sPROCESS]  @parm1 varchar (16) ,  @parm2 varchar (6) , @parm3 smalldatetime  as
select * from PJBSDET
where    PJBSDET.Project = @parm1
and PJBSDET.Schednbr= @parm2
and PJBSDET.Rel_Status <> 'Y'
and PJBSDET.Post_Date <> ''
and PJBSDET.Amount <> 0
and PJBSDET.Post_Date <= @parm3
order by PJBSDET.Post_Date
GO
