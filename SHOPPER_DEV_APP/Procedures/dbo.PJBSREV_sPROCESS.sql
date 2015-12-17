USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSREV_sPROCESS]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSREV_sPROCESS]  @parm1 varchar (16) ,  @parm2 varchar (6) , @parm3 smalldatetime  as
select * from PJBSREV
where    PJBSREV.Project = @parm1
and PJBSREV.Schednbr= @parm2
and PJBSREV.Rel_Status <> 'Y'
and PJBSREV.Post_Date <> ''
and PJBSREV.Amount <> 0
and PJBSREV.Post_Date <= @parm3
order by PJBSREV.Post_Date
GO
